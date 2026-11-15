"""Шинэ админ нэмэх скрипт. Нууц үгийг bcrypt-ээр шифрлээд санд хадгална.

Ажиллуулах: python create_admin.py
"""
import getpass
import os

import bcrypt
import psycopg
from dotenv import load_dotenv

load_dotenv()

email = input("Админы имэйл: ").strip().lower()
password = getpass.getpass("Нууц үг: ")
if len(password) < 8:
    raise SystemExit("Нууц үг дор хаяж 8 тэмдэгт байх ёстой")

password_hash = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

with psycopg.connect(os.environ["DATABASE_URL"]) as conn:
    with open(os.path.join(os.path.dirname(__file__), "sql", "admins.sql")) as f:
        conn.execute(f.read())
    conn.execute(
        """INSERT INTO admins (email, password_hash) VALUES (%s, %s)
           ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash""",
        (email, password_hash),
    )
print(f"Админ хадгалагдлаа: {email}")
