from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, desc
from typing import Optional
from pydantic import BaseModel
from datetime import datetime, timezone, timedelta

from app.core.database import get_db
from app.core.security import get_current_admin
from app.models.models import User, Recipe, AdminActivityLog, SiteStats, UserRole

router = APIRouter(prefix="/admin", tags=["admin"])

# ── Schemas ───────────────────────────────────────────────────────────────────

class RoleUpdate(BaseModel):
    role: str

async def log_admin_action(
    db: AsyncSession,
    admin_id: int,
    action: str,
    target_type: str,
    target_id: str,
    details: dict
):
    log = AdminActivityLog(
        admin_id=admin_id,
        action_type=action,
        target_type=target_type,
        target_id=target_id,
        details=details
    )
    db.add(log)
    await db.flush()

# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.get("/stats")
async def get_admin_stats(
    admin_id: int = Depends(get_current_admin),
    db: AsyncSession = Depends(get_db)
):
    total_users = await db.scalar(select(func.count()).select_from(User))
    total_recipes = await db.scalar(select(func.count()).select_from(Recipe))
    
    # Simple traffic stat from recipes
    total_views = await db.scalar(select(func.sum(Recipe.view_count))) or 0
    
    # Recent stats (last 24h)
    yesterday = datetime.now(timezone.utc) - timedelta(days=1)
    new_users_24h = await db.scalar(
        select(func.count()).select_from(User).where(User.created_at >= yesterday)
    )
    new_recipes_24h = await db.scalar(
        select(func.count()).select_from(Recipe).where(Recipe.created_at >= yesterday)
    )

    return {
        "total_users": total_users,
        "total_recipes": total_recipes,
        "total_views": total_views,
        "new_users_24h": new_users_24h,
        "new_recipes_24h": new_recipes_24h,
    }

@router.get("/logs")
async def get_admin_logs(
    limit: int = 50,
    admin_id: int = Depends(get_current_admin),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(AdminActivityLog, User.username)
        .join(User, AdminActivityLog.admin_id == User.id)
        .order_by(desc(AdminActivityLog.created_at))
        .limit(limit)
    )
    result = await db.execute(stmt)
    logs = []
    for log, username in result.all():
        logs.append({
            "id": log.id,
            "admin_username": username,
            "action": log.action_type,
            "target_type": log.target_type,
            "target_id": log.target_id,
            "details": log.details,
            "created_at": log.created_at.isoformat()
        })
    return logs

@router.get("/users")
async def list_users_admin(
    q: Optional[str] = None,
    limit: int = 50,
    offset: int = 0,
    admin_id: int = Depends(get_current_admin),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(User).order_by(User.id.asc()).limit(limit).offset(offset)
    if q:
        stmt = stmt.where(
            (User.username.ilike(f"%{q}%")) | (User.display_name.ilike(f"%{q}%"))
        )
    
    result = await db.execute(stmt)
    users = result.scalars().all()
    return [
        {
            "id": u.id,
            "username": u.username,
            "display_name": u.display_name or u.username,
            "role": u.role,
            "created_at": u.created_at.isoformat() if u.created_at else None
        }
        for u in users
    ]

@router.patch("/users/{target_user_id}/role")
async def update_user_role(
    target_user_id: int,
    body: RoleUpdate,
    admin_id: int = Depends(get_current_admin),
    db: AsyncSession = Depends(get_db)
):
    valid_roles = [r.value for r in UserRole]
    if body.role not in valid_roles:
        raise HTTPException(422, f"Invalid role. Must be one of: {', '.join(valid_roles)}")
        
    user = await db.scalar(select(User).where(User.id == target_user_id))
    if not user:
        raise HTTPException(404, "User not found")
        
    old_role = user.role
    user.role = body.role
    
    await log_admin_action(
        db, admin_id, "role_change", "user", str(user.id),
        {"username": user.username, "old_role": old_role, "new_role": body.role}
    )
    
    await db.commit()
    return {"ok": True, "new_role": body.role}
