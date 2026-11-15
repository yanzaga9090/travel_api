"""Travel Backend — FastAPI сервер.

Бүх тохиргоо .env файлаас уншигдана (кодонд нууц үг, хаяг байхгүй).
"""
import os
from datetime import date, datetime, timedelta, timezone
from decimal import Decimal

import bcrypt
import joblib
import jwt
import pandas as pd
import psycopg
from dotenv import load_dotenv
from typing import Literal

from fastapi import Depends, FastAPI, Header, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from psycopg.rows import dict_row
from pydantic import BaseModel, Field

from crud import register_crud

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
ALLOWED_ORIGINS = [o.strip() for o in os.getenv("ALLOWED_ORIGINS", "").split(",") if o.strip()]
MODEL_PATH = os.getenv("MODEL_PATH")  # Prompt 6-д загвар ачаалахад ашиглана
JWT_SECRET = os.getenv("JWT_SECRET")
JWT_EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRE_MINUTES", "60"))

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL .env файлд тохируулагдаагүй байна")
if not JWT_SECRET or len(JWT_SECRET) < 32:
    raise RuntimeError("JWT_SECRET .env файлд тохируулагдаагүй эсвэл хэт богино (32+ тэмдэгт) байна")

app = FastAPI(title="Travel Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
    allow_headers=["*"],
)


def get_connection():
    """Сантай шинэ холболт нээнэ. Мөр бүр dict хэлбэрээр ирнэ."""
    return psycopg.connect(DATABASE_URL, row_factory=dict_row)


@app.get("/health")
def health():
    """Сервер болон сан ажиллаж байгаа эсэхийг шалгана."""
    try:
        with get_connection() as conn:
            conn.execute("SELECT 1")
        return {"status": "ok", "database": "ok"}
    except psycopg.Error:
        raise HTTPException(status_code=503, detail="Database unavailable")


_DUMMY_HASH = bcrypt.hashpw(b"dummy-password", bcrypt.gensalt()).decode("utf-8")


class LoginRequest(BaseModel):
    email: str
    password: str


@app.post("/login")
def login(body: LoginRequest):
    """Имэйл, нууц үг зөв бол токен, буруу бол 401 буцаана."""
    with get_connection() as conn:
        admin = conn.execute(
            "SELECT admin_id, email, password_hash FROM admins WHERE email = %s",
            (body.email.strip().lower(),),
        ).fetchone()

    # Имэйл байхгүй үед ч ижил хугацаанд хариулахын тулд хуурамч hash-тай тулгана
    stored = admin["password_hash"] if admin else _DUMMY_HASH
    password_ok = bcrypt.checkpw(body.password.encode("utf-8"), stored.encode("utf-8"))
    if not admin or not password_ok:
        raise HTTPException(status_code=401, detail="Имэйл эсвэл нууц үг буруу")

    payload = {
        "sub": str(admin["admin_id"]),
        "email": admin["email"],
        "exp": datetime.now(timezone.utc) + timedelta(minutes=JWT_EXPIRE_MINUTES),
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm="HS256")
    return {"access_token": token, "token_type": "bearer"}


def require_admin(authorization: str | None = Header(default=None)) -> dict:
    """Authorization: Bearer <токен> толгойг шалгана.

    Дараах тохиолдол бүрт 401 буцаана:
      • толгой байхгүй, эсвэл "Bearer " гэж эхлээгүй
      • токены гарын үсэг буруу (JWT_SECRET-ээр зураагүй / өөрчилсөн)
      • токены хугацаа дууссан (exp)
      • HS256-аас өөр алгоритм (жишээ нь "none") ашигласан
    """
    unauthorized = HTTPException(
        status_code=401,
        detail="Нэвтрэх шаардлагатай",
        headers={"WWW-Authenticate": "Bearer"},
    )
    if not authorization:
        raise unauthorized
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token.strip():
        raise unauthorized
    try:
        payload = jwt.decode(
            token.strip(), JWT_SECRET, algorithms=["HS256"], options={"require": ["exp", "sub"]}
        )
    except jwt.ExpiredSignatureError:
        raise HTTPException(401, "Токены хугацаа дууссан. Дахин нэвтэрнэ үү.",
                            headers={"WWW-Authenticate": "Bearer"})
    except jwt.PyJWTError:
        raise unauthorized
    return payload


@app.get("/admin/stats")
def admin_stats(admin: dict = Depends(require_admin)):
    """Хяналтын самбарын тоо баримт ба батлагдаагүй сүүлийн 5 захиалга."""
    with get_connection() as conn:
        counts = conn.execute(
            """
            SELECT
                (SELECT COUNT(*) FROM tours)                                AS tours,
                (SELECT COUNT(*) FROM bookings)                             AS bookings,
                (SELECT COUNT(*) FROM bookings WHERE status = 'pending')    AS pending,
                (SELECT COALESCE(SUM(amount), 0) FROM payments)             AS revenue
            """
        ).fetchone()
        pending_list = conn.execute(
            """
            SELECT b.booking_id, b.people, b.booked_at, b.status,
                   t.name AS tour_name, c.full_name AS customer_name
            FROM bookings b
            JOIN tours t     ON t.tour_id = b.tour_id
            JOIN customers c ON c.customer_id = b.customer_id
            WHERE b.status = 'pending'
            ORDER BY b.booked_at DESC, b.booking_id DESC
            LIMIT 5
            """
        ).fetchall()
    return {**counts, "pending_bookings": pending_list}


# =====================================================================
#  Аялал (tours) — ерөнхий CRUD-аар
# =====================================================================
class TourIn(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    destination: str | None = Field(default=None, max_length=50)
    days: int = Field(gt=0)
    price: Decimal = Field(gt=0)
    start_date: date | None = None
    guide_id: int | None = None


register_crud(
    app,
    path="/tours",
    table="tours",
    id_col="tour_id",
    model=TourIn,
    get_connection=get_connection,
    auth=require_admin,
    public_list=True,  # GET /tours нээлттэй хэвээр (Prompt 0)
    list_sql="""
        SELECT t.*, g.full_name AS guide_name, COUNT(b.booking_id)::int AS bookings_count
        FROM tours t
        LEFT JOIN guides g   ON g.guide_id = t.guide_id
        LEFT JOIN bookings b ON b.tour_id = t.tour_id
        GROUP BY t.tour_id, g.full_name
        ORDER BY t.tour_id DESC
    """,
    in_use_sql="SELECT COUNT(*) FROM bookings WHERE tour_id = %s",
    in_use_message=(
        "Энэ аяллыг устгах боломжгүй: {n} захиалга бүртгэлтэй байна. "
        "Эхлээд захиалгуудыг нь өөр аялал руу шилжүүлэх эсвэл устгах хэрэгтэй."
    ),
    not_found_message="Аялал олдсонгүй.",
)


@app.get("/admin/guides", dependencies=[Depends(require_admin)])
def guide_options():
    """Аялал засах формын «Хөтөч» сонголтод зориулсан жагсаалт."""
    with get_connection() as conn:
        return conn.execute("SELECT guide_id, full_name FROM guides ORDER BY full_name").fetchall()


# =====================================================================
#  Захиалга (bookings) — мөн ерөнхий CRUD-аар
# =====================================================================
BOOKING_STATUSES = {"pending", "confirmed", "cancelled"}
BookingStatus = Literal["pending", "confirmed", "cancelled"]


class BookingIn(BaseModel):
    tour_id: int
    customer_id: int
    people: int = Field(gt=0)
    status: BookingStatus = "pending"


BOOKINGS_LIST_SQL = """
    SELECT b.*, t.name AS tour_name, c.full_name AS customer_name,
           COALESCE(SUM(p.amount), 0) AS paid_amount,
           COUNT(p.payment_id) > 0    AS has_payment
    FROM bookings b
    JOIN tours t      ON t.tour_id = b.tour_id
    JOIN customers c  ON c.customer_id = b.customer_id
    LEFT JOIN payments p ON p.booking_id = b.booking_id
    GROUP BY b.booking_id, t.name, c.full_name
"""

register_crud(
    app,
    path="/bookings",
    table="bookings",
    id_col="booking_id",
    model=BookingIn,
    get_connection=get_connection,
    auth=require_admin,
    list_sql=BOOKINGS_LIST_SQL,
    list_filters={"status": BOOKING_STATUSES},
    list_limit=50,
    in_use_sql="SELECT COUNT(*) FROM payments WHERE booking_id = %s",
    in_use_message=(
        "Энэ захиалга төлбөртэй тул устгах боломжгүй. "
        "Оронд нь «Цуцлах» товчийг ашиглана уу."
    ),
    not_found_message="Захиалга олдсонгүй.",
)


class StatusIn(BaseModel):
    status: BookingStatus


@app.patch("/bookings/{booking_id}/status", dependencies=[Depends(require_admin)])
def set_booking_status(booking_id: int, body: StatusIn):
    """Захиалгын төлөвийг солино (Батлах → confirmed, Цуцлах → cancelled)."""
    with get_connection() as conn:
        cur = conn.execute(
            "UPDATE bookings SET status = %s WHERE booking_id = %s", (body.status, booking_id)
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "Захиалга олдсонгүй.")
        return conn.execute(
            f"SELECT * FROM ({BOOKINGS_LIST_SQL}) AS x WHERE booking_id = %s", (booking_id,)
        ).fetchone()


@app.get("/admin/customers", dependencies=[Depends(require_admin)])
def customer_options():
    """Захиалгын формын «Үйлчлүүлэгч» сонголтод зориулсан жагсаалт."""
    with get_connection() as conn:
        return conn.execute(
            "SELECT customer_id, full_name, country FROM customers ORDER BY full_name"
        ).fetchall()


@app.get("/admin/tour-options", dependencies=[Depends(require_admin)])
def tour_options():
    """Захиалгын формын «Аялал» сонголтод зориулсан жагсаалт."""
    with get_connection() as conn:
        return conn.execute(
            "SELECT tour_id, name, start_date FROM tours ORDER BY name"
        ).fetchall()


# =====================================================================
#  Үйлчлүүлэгч (customers), Хөтөч (guides) — мөн ерөнхий CRUD-аар
# =====================================================================
class CustomerIn(BaseModel):
    full_name: str = Field(min_length=1, max_length=100)
    country: str | None = Field(default=None, max_length=50)
    email: str | None = Field(default=None, max_length=100, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


register_crud(
    app,
    path="/customers",
    table="customers",
    id_col="customer_id",
    model=CustomerIn,
    get_connection=get_connection,
    auth=require_admin,
    list_sql="""
        SELECT c.*, COUNT(b.booking_id)::int AS bookings_count
        FROM customers c
        LEFT JOIN bookings b ON b.customer_id = c.customer_id
        GROUP BY c.customer_id
    """,
    in_use_sql="SELECT COUNT(*) FROM bookings WHERE customer_id = %s",
    in_use_message=(
        "Энэ үйлчлүүлэгчийг устгах боломжгүй: {n} захиалга бүртгэлтэй байна. "
        "Эхлээд захиалгуудыг нь устгах хэрэгтэй."
    ),
    not_found_message="Үйлчлүүлэгч олдсонгүй.",
)


class GuideIn(BaseModel):
    full_name: str = Field(min_length=1, max_length=100)
    language: str | None = Field(default=None, max_length=30)
    experience_years: int | None = Field(default=None, ge=0)


register_crud(
    app,
    path="/guides",
    table="guides",
    id_col="guide_id",
    model=GuideIn,
    get_connection=get_connection,
    auth=require_admin,
    list_sql="""
        SELECT g.*, COUNT(t.tour_id)::int AS tours_count
        FROM guides g
        LEFT JOIN tours t ON t.guide_id = g.guide_id
        GROUP BY g.guide_id
    """,
    in_use_sql="SELECT COUNT(*) FROM tours WHERE guide_id = %s",
    in_use_message=(
        "Энэ хөтчийг устгах боломжгүй: {n} аялал хариуцаж байна. "
        "Эхлээд тэдгээр аяллыг өөр хөтөчид шилжүүлэх хэрэгтэй."
    ),
    not_found_message="Хөтөч олдсонгүй.",
)


# =====================================================================
#  Эрэлт таамаглах (Colab-д сургасан demand_model.joblib)
# =====================================================================
# Colab-д сургахдаа ашигласан баганын нэр, дараалал — яг ижил байх ёстой
FEATURES = ["price_per_day", "guide_experience", "days"]


def load_model():
    """MODEL_PATH-аас загварыг ачаална. Зам нь main.py-аас харьцангуй байж болно."""
    if not MODEL_PATH:
        return None
    path = MODEL_PATH if os.path.isabs(MODEL_PATH) else os.path.join(os.path.dirname(__file__), MODEL_PATH)
    if not os.path.exists(path):
        print(f"[анхаар] Загвар олдсонгүй: {path}")
        return None
    return joblib.load(path)


demand_model = load_model()


def predict(rows: list[dict]) -> list[float]:
    """Загвараар таамаглана. Сөрөг бол 0, 1 оронтой бутархай."""
    if demand_model is None:
        raise HTTPException(503, "Таамаглах загвар ачаалагдаагүй байна (MODEL_PATH-ыг шалгана уу).")
    X = pd.DataFrame(rows, columns=FEATURES).astype(float)
    return [round(max(0.0, float(v)), 1) for v in demand_model.predict(X)]


@app.get("/predict-demand", dependencies=[Depends(require_admin)])
def predict_demand(
    price_per_day: float = Query(gt=0, description="Өдрийн үнэ (₮)"),
    guide_experience: float = Query(ge=0, description="Хөтчийн туршлага (жил)"),
    days: int = Query(gt=0, description="Хоног"),
):
    """Шинэ аяллын захиалгын тоог таамаглана."""
    row = {"price_per_day": price_per_day, "guide_experience": guide_experience, "days": days}
    return {**row, "predicted_bookings": predict([row])[0]}


@app.get("/demand/tours", dependencies=[Depends(require_admin)])
def demand_tours(limit: int = Query(default=10, ge=1, le=150)):
    """Хамгийн их захиалгатай аяллууд: бодит захиалга ба загварын таамаглал."""
    with get_connection() as conn:
        rows = conn.execute(
            """
            SELECT t.tour_id, t.name, t.destination, t.days, t.price,
                   ROUND(t.price / t.days)::float AS price_per_day,
                   g.full_name                    AS guide_name,
                   g.experience_years             AS guide_experience,
                   COUNT(b.booking_id)::int       AS actual_bookings
            FROM tours t
            JOIN guides g        ON g.guide_id = t.guide_id
            LEFT JOIN bookings b ON b.tour_id = t.tour_id
            WHERE g.experience_years IS NOT NULL
            GROUP BY t.tour_id, g.full_name, g.experience_years
            ORDER BY actual_bookings DESC, t.tour_id
            LIMIT %s
            """,
            (limit,),
        ).fetchall()
    if rows:
        preds = predict(rows)
        for r, p in zip(rows, preds):
            r["predicted_bookings"] = p
            r["difference"] = round(r["actual_bookings"] - p, 1)
    return rows
