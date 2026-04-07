import os
import json
import asyncio
import subprocess
from typing import List, Optional, Dict
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.models import Recipe, User
from dotenv import load_dotenv

class AIAssistantService:
    def __init__(self):
        # Force load .env from absolute path to ensure the key is found regardless of CWD
        load_dotenv("/home/q/legends/recipes/backend/.env")
        self.api_key = os.getenv("GEMINI_API_KEY")
        
        # Base URL for stable v1beta (v1beta/models/gemini-1.5-flash) - CONFIRMED on Pi
        self.base_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
        
        self.system_instruction = """
        Your name is RAUL THE CHEF, the spicy, witty, and exceptionally talented Head Chef of RecipeHub.
        You don't just build meal plans; you architect FLAVOR. 

        PERSONALITY:
        - Funny, catchy, and high-energy. Use culinary puns where appropriate.
        - You're not just an AI; you're the user's best friend in the kitchen.
        - Address the user as 'Amigo' or 'Chef'.
        """

    def _sync_curl_call(self, url: str, json_payload: str) -> str:
        """
        Synchronous wrapper for curl call using bulletproof check_output.
        """
        cmd = [
            "curl", "-s", "-X", "POST", url,
            "-H", "Content-Type: application/json",
            "-H", "User-Agent: curl/7.74.0",
            "-d", json_payload
        ]
        
        try:
            # check_output is synchronous and rock-solid on all Python versions
            output = subprocess.check_output(cmd, stderr=subprocess.STDOUT, text=True)
            return output
        except subprocess.CalledProcessError as e:
            return json.dumps({"error": f"Curl process failed: {e.output}"})
        except Exception as e:
            return json.dumps({"error": str(e)})

    async def chat(self, message: str, history: list = None) -> str:
        """
        Raul's simple REST chat logic - now forcing CURL via threaded synchronous subprocess.
        This is the definitive architecture to guarantee success on your Pi.
        """
        if not self.api_key:
            return "Missing API Key, Amigo!"

        url = f"{self.base_url}?key={self.api_key}"
        
        # Structure the multi-turn payload
        contents = []
        if history:
            for msg in history:
                role = "user" if msg.get("role") == "user" else "model"
                content = msg.get("content") or msg.get("parts", [{}])[0].get("text", "")
                if content:
                    contents.append({
                        "role": role,
                        "parts": [{"text": content}]
                    })
        
        contents.append({"role": "user", "parts": [{"text": message}]})

        payload = {
            "contents": contents,
            "systemInstruction": {"parts": [{"text": self.system_instruction}]},
            "generationConfig": {"temperature": 0.8, "topP": 0.95, "maxOutputTokens": 2048}
        }

        try:
            json_payload = json.dumps(payload)
            
            # Use to_thread to keep the event loop running during the bulletproof check_output call
            stdout_str = await asyncio.to_thread(self._sync_curl_call, url, json_payload)
            
            data = json.loads(stdout_str)
            
            if "error" in data:
                return f"Raul's Brain is offline! ({data['error']})"
                
            if "candidates" in data and data["candidates"]:
                return data["candidates"][0]["content"]["parts"][0]["text"]
            else:
                return f"Raul's Brain Error: {json.dumps(data)}"

        except Exception as e:
            return f"Raul burned the toast, Amigo! ({str(e)})"

    async def generate_flexible_plan(self, user: User, db: AsyncSession, weeks: int = 1, diet_type: str = "keto") -> Dict:
        return {"error": "Raul is updating"}

ai_assistant = AIAssistantService()
