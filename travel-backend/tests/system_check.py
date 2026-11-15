"""Бүх системийн шалгалт (Prompt 8).

Ажиллуулах (backend асаалттай байх ёстой):
    API_URL=<backend хаяг> ADMIN_EMAIL=<имэйл> ADMIN_PASSWORD=<нууц үг> \\
    FRONTEND_ORIGIN=<frontend хаяг> python tests/system_check.py

Хаяг, нууц үг кодонд бичигдээгүй — орчны хувьсагчаас уншина.
Туршилтаар нэмсэн мөрүүдийг төгсгөлд нь заавал устгана.
"""
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

API = os.environ["API_URL"].rstrip("/")
EMAIL = os.environ["ADMIN_EMAIL"]
PASSWORD = os.environ["ADMIN_PASSWORD"]
ORIGIN = os.environ.get("FRONTEND_ORIGIN", "")
FRONTEND_DIR = Path(__file__).resolve().parents[2] / "travel-frontend"

results: list[tuple[str, str, bool, str]] = []  # (бүлэг, шалгалт, амжилттай?, дэлгэрэнгүй)
cleanup: list[str] = []  # туршилтын мөрүүдийг устгах замууд (сүүлээс нь)


def check(group: str, name: str, ok: bool, detail: str = "") -> bool:
    results.append((group, name, bool(ok), detail))
    return bool(ok)


def call(method: str, path: str, token: str | None = None, body=None, headers=None):
    h = {"Content-Type": "application/json", **(headers or {})}
    if token:
        h["Authorization"] = "Bearer " + token
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(API + path, method=method, headers=h, data=data)
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            raw = r.read()
            try:
                body = json.loads(raw) if raw else None
            except ValueError:
                body = raw.decode(errors="replace")  # жишээ нь CORS-ийн "OK" хариу
            return r.status, body, dict(r.headers)
    except urllib.error.HTTPError as e:
        raw = e.read()
        try:
            return e.code, json.loads(raw), dict(e.headers)
        except ValueError:
            return e.code, raw.decode(errors="replace"), dict(e.headers)


def detail_of(body) -> str:
    return body.get("detail", "") if isinstance(body, dict) and isinstance(body.get("detail"), str) else ""


# ---------------------------------------------------------------- /health
def test_health():
    c, b, _ = call("GET", "/health")
    check("Сервер", "GET /health → 200, сан холбогдсон", c == 200 and b.get("database") == "ok", f"{c} {b}")


# ---------------------------------------------------------------- Нэвтрэлт
def test_login() -> str | None:
    c, b, _ = call("POST", "/login", body={"email": EMAIL, "password": PASSWORD})
    ok = check("Нэвтрэлт", "Зөв имэйл, нууц үг → токен", c == 200 and "access_token" in (b or {}), str(c))
    c2, _, _ = call("POST", "/login", body={"email": EMAIL, "password": PASSWORD + "x"})
    check("Нэвтрэлт", "Буруу нууц үг → 401", c2 == 401, str(c2))
    c3, _, _ = call("POST", "/login", body={"email": "no-such-admin@example.com", "password": "x"})
    check("Нэвтрэлт", "Байхгүй имэйл → 401", c3 == 401, str(c3))
    return b["access_token"] if ok else None


# ---------------------------------------------------------------- 401
def test_unauthorized():
    protected = [
        ("GET", "/admin/stats"),
        ("POST", "/tours"), ("PUT", "/tours/1"), ("DELETE", "/tours/1"),
        ("GET", "/bookings"), ("POST", "/bookings"), ("PUT", "/bookings/1"), ("DELETE", "/bookings/1"),
        ("PATCH", "/bookings/1/status"),
        ("GET", "/customers"), ("POST", "/customers"), ("PUT", "/customers/1"), ("DELETE", "/customers/1"),
        ("GET", "/guides"), ("POST", "/guides"), ("PUT", "/guides/1"), ("DELETE", "/guides/1"),
        ("GET", "/predict-demand?price_per_day=1&guide_experience=1&days=1"), ("GET", "/demand/tours"),
    ]
    bad = []
    for m, p in protected:
        c, _, _ = call(m, p, body={} if m in ("POST", "PUT", "PATCH") else None)
        if c != 401:
            bad.append(f"{m} {p}={c}")
    check("Хамгаалалт", f"Токенгүй {len(protected)} хүсэлт → бүгд 401", not bad, ", ".join(bad))
    c, _, _ = call("GET", "/admin/stats", token="abc.def.ghi")
    check("Хамгаалалт", "Хуурамч токен → 401", c == 401, str(c))
    c, _, _ = call("GET", "/tours")
    check("Хамгаалалт", "GET /tours нээлттэй (Prompt 0)", c == 200, str(c))


# ---------------------------------------------------------------- CRUD туслах
def crud_cycle(group, path, id_field, create, update, token, check_top=True):
    c, row, _ = call("POST", path, token, create)
    if not check(group, "Нэмэх → 201", c == 201, f"{c} {detail_of(row)}"):
        return None
    new_id = row[id_field]
    cleanup.append(f"{path}/{new_id}")
    if check_top:
        _, rows, _ = call("GET", path, token)
        check(group, "Шинээр нэмсэн нь хамгийн дээр", rows and rows[0][id_field] == new_id)
    c, row2, _ = call("PUT", f"{path}/{new_id}", token, update)
    first_key = next(iter(update))
    check(group, "Засах → 200", c == 200 and row2[first_key] == update[first_key], str(c))
    return new_id


def delete_ok(group, path, token, label="Устгах (холбоогүй) → 200"):
    c, _, _ = call("DELETE", path, token)
    if check(group, label, c == 200, str(c)) and path in cleanup:
        cleanup.remove(path)


def delete_blocked(group, path, token, label):
    c, b, _ = call("DELETE", path, token)
    msg = detail_of(b)
    check(group, label, c == 409 and "боломжгүй" in msg, f"{c}: {msg}")


def first_id(sql_path, token, id_field, pred):
    _, rows, _ = call("GET", sql_path, token)
    return next((r[id_field] for r in rows if pred(r)), None)


# ---------------------------------------------------------------- 4 цэсний CRUD
def test_crud(token):
    # --- Хөтөч ---
    g = "Хөтөч"
    gid = crud_cycle(g, "/guides", "guide_id",
                     {"full_name": "ТЕСТ хөтөч", "language": "Англи", "experience_years": 5},
                     {"full_name": "ТЕСТ хөтөч 2", "language": "Япон", "experience_years": 6}, token)
    busy = first_id("/guides", token, "guide_id", lambda r: r["tours_count"] > 0)
    delete_blocked(g, f"/guides/{busy}", token, "Аялалтай хөтөч устгахгүй → 409 + мессеж")

    # --- Үйлчлүүлэгч ---
    g = "Үйлчлүүлэгч"
    cid = crud_cycle(g, "/customers", "customer_id",
                     {"full_name": "ТЕСТ үйлчлүүлэгч", "country": "Монгол", "email": "test@example.com"},
                     {"full_name": "ТЕСТ үйлчлүүлэгч 2", "country": "Япон", "email": "t2@example.com"}, token)
    c, _, _ = call("POST", "/customers", token, {"full_name": "x", "email": "муу-имэйл"})
    check(g, "Буруу и-мэйл → татгалзана (422)", c == 422, str(c))
    busy = first_id("/customers", token, "customer_id", lambda r: r["bookings_count"] > 0)
    delete_blocked(g, f"/customers/{busy}", token, "Захиалгатай үйлчлүүлэгч устгахгүй → 409")

    # --- Аялал ---
    g = "Аялал"
    tid = crud_cycle(g, "/tours", "tour_id",
                     {"name": "ТЕСТ аялал", "destination": "Тест", "days": 3, "price": 300000, "guide_id": gid},
                     {"name": "ТЕСТ аялал 2", "destination": "Тест", "days": 4, "price": 400000, "guide_id": gid},
                     token)
    c, _, _ = call("POST", "/tours", token, {"name": "x", "days": 0, "price": 1})
    check(g, "Хоног = 0 → татгалзана (422)", c == 422, str(c))
    busy = first_id("/tours", token, "tour_id", lambda r: r["bookings_count"] > 0)
    delete_blocked(g, f"/tours/{busy}", token, "Захиалгатай аялал устгахгүй → 409")

    # --- Захиалга ---
    g = "Захиалга"
    if tid and cid:
        bid = crud_cycle(g, "/bookings", "booking_id",
                         {"tour_id": tid, "customer_id": cid, "people": 2, "status": "pending"},
                         {"people": 3, "tour_id": tid, "customer_id": cid, "status": "pending"}, token)
        _, rows, _ = call("GET", "/bookings", token)
        check(g, "Жагсаалт ≤ 50 (сүүлийн 50)", len(rows) <= 50, f"{len(rows)}")
        _, rows, _ = call("GET", "/bookings?status=pending", token)
        check(g, "Төлөвөөр шүүх (pending)", rows and all(r["status"] == "pending" for r in rows), f"{len(rows)}")
        c, r, _ = call("PATCH", f"/bookings/{bid}/status", token, {"status": "confirmed"})
        check(g, "Батлах → confirmed", c == 200 and r["status"] == "confirmed", str(c))
        c, r, _ = call("PATCH", f"/bookings/{bid}/status", token, {"status": "cancelled"})
        check(g, "Цуцлах → cancelled", c == 200 and r["status"] == "cancelled", str(c))
        paid = first_id("/bookings?status=confirmed", token, "booking_id", lambda r: r["has_payment"])
        delete_blocked(g, f"/bookings/{paid}", token, "Төлбөртэй захиалга устгахгүй → 409, «Цуцлах» санал болгоно")
        c, b, _ = call("POST", "/bookings", token, {"tour_id": 999999999, "customer_id": cid, "people": 1})
        check(g, "Байхгүй аялал сонговол → 400", c == 400, f"{c}: {detail_of(b)}")
        delete_ok(g, f"/bookings/{bid}", token)

    # Холбоогүй болсон туршилтын мөрүүдийг устгах (захиалга → аялал → үйлчлүүлэгч → хөтөч)
    if tid:
        delete_ok("Аялал", f"/tours/{tid}", token)
    if cid:
        delete_ok("Үйлчлүүлэгч", f"/customers/{cid}", token)
    if gid:
        delete_ok("Хөтөч", f"/guides/{gid}", token)


# ---------------------------------------------------------------- Хяналт
def test_stats(token):
    c, s, _ = call("GET", "/admin/stats", token)
    keys = {"tours", "bookings", "pending", "revenue", "pending_bookings"}
    check("Хяналт", "/admin/stats → 4 тоо + жагсаалт", c == 200 and keys <= set(s), str(c))
    if c == 200:
        check("Хяналт", "Батлагдаагүй ≤ 5 захиалга, бүгд pending",
              len(s["pending_bookings"]) <= 5 and all(b["status"] == "pending" for b in s["pending_bookings"]))


# ---------------------------------------------------------------- Эрэлт
def test_demand(token):
    g = "Эрэлт таамаглал"
    c, r, _ = call("GET", "/predict-demand?price_per_day=180000&guide_experience=12&days=5", token)
    ok = c == 200 and isinstance(r.get("predicted_bookings"), (int, float))
    check(g, "/predict-demand → тоо буцаана", ok, f"{c} {r}")
    if ok:
        v = r["predicted_bookings"]
        check(g, "1 оронтой бутархай", round(v, 1) == v, str(v))
    c, r, _ = call("GET", "/predict-demand?price_per_day=5000000&guide_experience=0&days=1", token)
    check(g, "Сөрөг таамаглал → 0", c == 200 and r["predicted_bookings"] == 0, f"{r}")
    c, _, _ = call("GET", "/predict-demand?price_per_day=-1&guide_experience=1&days=1", token)
    check(g, "Сөрөг үнэ → 422", c == 422, str(c))
    c, rows, _ = call("GET", "/demand/tours", token)
    ok = c == 200 and len(rows) == 10
    check(g, "/demand/tours → 10 аялал", ok, f"{c} {len(rows) if isinstance(rows, list) else rows}")
    if ok:
        actual = [r["actual_bookings"] for r in rows]
        check(g, "Бодит захиалгаар буурахаар эрэмбэлсэн", actual == sorted(actual, reverse=True), str(actual))
        check(g, "Бодит + таамаглал хоёулаа байна",
              all("predicted_bookings" in r and "actual_bookings" in r for r in rows))
    c, rows, _ = call("GET", "/demand/tours?limit=5", token)
    check(g, "Хяналтын эрэлттэй 5 аялал", c == 200 and len(rows) == 5, str(c))


# ---------------------------------------------------------------- CORS
def test_cors():
    if not ORIGIN:
        check("CORS", "FRONTEND_ORIGIN өгөөгүй — алгаслаа", True)
        return
    _, _, h = call("OPTIONS", "/bookings/1/status", headers={
        "Origin": ORIGIN, "Access-Control-Request-Method": "PATCH",
        "Access-Control-Request-Headers": "authorization,content-type"})
    allowed = {k.lower(): v for k, v in h.items()}.get("access-control-allow-origin")
    check("CORS", "Frontend-ийн хаягийг зөвшөөрсөн", allowed == ORIGIN, str(allowed))
    _, _, h = call("OPTIONS", "/tours", headers={"Origin": "https://evil.example.com",
                                                   "Access-Control-Request-Method": "POST"})
    allowed = {k.lower(): v for k, v in h.items()}.get("access-control-allow-origin")
    check("CORS", "Танихгүй сайтыг зөвшөөрөхгүй", allowed is None, str(allowed))


# ---------------------------------------------------------------- Frontend (статик)
def test_frontend_static():
    g = "Frontend"
    html = (FRONTEND_DIR / "index.html").read_text()
    app = (FRONTEND_DIR / "app.js").read_text()
    menus = re.findall(r'data-page="(\w+)">([^<]+)</a>', html)
    names = [n.split(" ", 1)[-1] for _, n in menus]
    want = ["Хяналт", "Аялал", "Захиалга", "Үйлчлүүлэгч", "Хөтөч", "Эрэлт таамаглах", "Facebook"]
    check(g, "7 цэс зөв дараалалтай", names == want, ", ".join(names))
    check(g, "Facebook → «Тун удахгүй»", re.search(r'facebook:.*renderSoon\([^)]*"Тун удахгүй"', app) is not None)
    check(g, "4 CRUD цэс ерөнхий createCrudPage-аар",
          all(f"{p}Page = createCrudPage" in app for p in ("tours", "bookings", "customers", "guides")))
    check(g, "Хүсэлт бүрт токен илгээдэг", '"Bearer " + getToken()' in app)
    check(g, "401 ирвэл нэвтрэх хуудас руу буцна", re.search(r"status === 401\)\s*\{\s*//[^\n]*\n\s*logout\(", app) is not None)
    check(g, "API хаяг зөвхөн config.js-ээс", "API_URL" in (FRONTEND_DIR / "config.js").read_text()
          and not re.search(r"https?://", app + (FRONTEND_DIR / "crud.js").read_text()))


# ---------------------------------------------------------------- Ажиллуулах
def main():
    test_health()
    token = test_login()
    test_unauthorized()
    test_cors()
    test_frontend_static()
    if token:
        try:
            test_stats(token)
            test_crud(token)
            test_demand(token)
        finally:
            for path in reversed(cleanup):  # алдаа гарсан ч туршилтын мөрүүдийг цэвэрлэнэ
                call("DELETE", path, token)

    passed = sum(ok for *_, ok, _ in results)
    group = None
    for grp, name, ok, detail in results:
        if grp != group:
            print(f"\n[{grp}]")
            group = grp
        print(f"  {'✅' if ok else '❌'} {name}" + (f"   ({detail})" if not ok and detail else ""))
    print(f"\nДүн: {passed}/{len(results)} амжилттай")
    if cleanup:
        print("Анхаар: цэвэрлэгдээгүй туршилтын мөр:", cleanup)
    sys.exit(0 if passed == len(results) else 1)


if __name__ == "__main__":
    main()
