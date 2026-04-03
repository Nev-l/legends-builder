"""
Create or reset the admin account.
Usage: python create_admin.py --email you@example.com --password yourpassword --username admin
"""
import asyncio, argparse, sys, os
sys.path.insert(0, os.path.dirname(__file__))
os.chdir(os.path.dirname(__file__))

from sqlalchemy import select
from app.core.database import AsyncSessionLocal
from app.core.security import hash_password
from app.models.models import User


async def main(email: str, username: str, password: str):
    async with AsyncSessionLocal() as db:
        user = await db.scalar(select(User).where(User.email == email))
        if user:
            user.hashed_password = hash_password(password)
            user.username = username
            user.is_active = True
            await db.commit()
            print(f"Updated existing user: {email}")
        else:
            user = User(
                email=email,
                username=username,
                hashed_password=hash_password(password),
                display_name="Admin",
                is_active=True,
            )
            db.add(user)
            await db.commit()
            print(f"Created admin user: {email}  (id={user.id})")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--email",    required=True)
    p.add_argument("--username", default="admin")
    p.add_argument("--password", required=True)
    args = p.parse_args()
    asyncio.run(main(args.email, args.username, args.password))
