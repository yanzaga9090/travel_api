"""Ерөнхий CRUD (Нэмэх / Унших / Засах / Устгах) үүсгэгч.

Нэг хүснэгтэд зориулсан 4 endpoint-ийг нэг дуудлагаар бүртгэнэ:

    GET    /{path}        → жагсаалт (шинэ нь хамгийн дээр)
    POST   /{path}        → шинээр нэмэх           (админ шаардлагатай)
    PUT    /{path}/{id}   → засах                  (админ шаардлагатай)
    DELETE /{path}/{id}   → устгах                 (админ шаардлагатай)

Жишээ:
    register_crud(app, path="/guides", table="guides", id_col="guide_id",
                  model=GuideIn, get_connection=get_connection, auth=require_admin)
"""
from typing import Callable

import psycopg
from fastapi import Depends, FastAPI, HTTPException, Request
from psycopg import sql
from pydantic import BaseModel


def register_crud(
    app: FastAPI,
    *,
    path: str,
    table: str,
    id_col: str,
    model: type[BaseModel],
    get_connection: Callable,
    auth: Callable,
    list_sql: str | None = None,
    public_list: bool = False,
    list_filters: dict[str, set[str] | None] | None = None,
    list_limit: int | None = None,
    in_use_sql: str | None = None,
    in_use_message: str = "Энэ мөрийг өөр мэдээлэл ашиглаж байгаа тул устгах боломжгүй.",
    not_found_message: str = "Олдсонгүй.",
) -> None:
    """
    list_sql       — жагсаалтын SELECT (JOIN, COUNT хийх бол). Байхгүй бол SELECT * ... ORDER BY id DESC.
    public_list    — True бол жагсаалтыг токенгүй уншиж болно.
    list_filters   — ?талбар=утга шүүлтүүр. {"status": {"pending", ...}} (None = дурын утга).
    list_limit     — жагсаалтад хамгийн ихдээ хэдэн мөр буцаах (сүүлийнх нь).
    in_use_sql     — устгахаас өмнө "хэдэн мөр үүнийг ашиглаж байна" гэж тоолох SQL (%s = id).
    in_use_message — {n} нь тоогоор солигдоно.
    """
    tbl, idc = sql.Identifier(table), sql.Identifier(id_col)
    columns = list(model.model_fields)

    def _db_error(e: psycopg.Error, deleting: bool = False):
        if isinstance(e, psycopg.errors.ForeignKeyViolation):
            if deleting:
                raise HTTPException(409, in_use_message.format(n="зарим"))
            raise HTTPException(400, "Сонгосон холбоотой мэдээлэл (аялал, хөтөч г.м.) олдсонгүй.")
        if isinstance(e, (psycopg.errors.UniqueViolation,)):
            raise HTTPException(409, "Ийм утга аль хэдийн бүртгэлтэй байна.")
        if isinstance(e, (psycopg.errors.CheckViolation, psycopg.errors.DataError)):
            raise HTTPException(400, "Оруулсан утга буруу байна.")
        raise HTTPException(500, "Сантай ажиллахад алдаа гарлаа.")

    def _fetch_one(conn, item_id: int):
        """Нэг мөрийг жагсаалтын хэлбэрээр (JOIN-тэй) нь буцаана."""
        if list_sql:
            q = sql.SQL("SELECT * FROM ({}) AS x WHERE {} = %s").format(sql.SQL(list_sql), idc)
        else:
            q = sql.SQL("SELECT * FROM {} WHERE {} = %s").format(tbl, idc)
        return conn.execute(q, (item_id,)).fetchone()

    # ---------- GET (жагсаалт) ----------
    def list_items(request: Request):
        base = sql.SQL(list_sql) if list_sql else sql.SQL("SELECT * FROM {}").format(tbl)
        where, params = [], []
        for key, allowed in (list_filters or {}).items():
            value = request.query_params.get(key)
            if not value:
                continue
            if allowed is not None and value not in allowed:
                raise HTTPException(400, f"«{key}» шүүлтүүрийн утга буруу.")
            where.append(sql.SQL("{} = %s").format(sql.Identifier(key)))
            params.append(value)
        q = sql.SQL("SELECT * FROM ({}) AS x").format(base)
        if where:
            q += sql.SQL(" WHERE ") + sql.SQL(" AND ").join(where)
        q += sql.SQL(" ORDER BY {} DESC").format(idc)
        if list_limit:
            q += sql.SQL(" LIMIT {}").format(sql.Literal(list_limit))
        with get_connection() as conn:
            return conn.execute(q, params).fetchall()

    list_deps = [] if public_list else [Depends(auth)]
    app.get(path, dependencies=list_deps, name=f"list_{table}")(list_items)

    # ---------- POST (нэмэх) ----------
    def create_item(body: model):  # type: ignore[valid-type]
        data = body.model_dump()
        q = sql.SQL("INSERT INTO {} ({}) VALUES ({}) RETURNING {}").format(
            tbl,
            sql.SQL(", ").join(map(sql.Identifier, columns)),
            sql.SQL(", ").join(sql.Placeholder() * len(columns)),
            idc,
        )
        try:
            with get_connection() as conn:
                new_id = conn.execute(q, [data[c] for c in columns]).fetchone()[id_col]
                return _fetch_one(conn, new_id)
        except psycopg.Error as e:
            _db_error(e)

    app.post(path, status_code=201, dependencies=[Depends(auth)], name=f"create_{table}")(create_item)

    # ---------- PUT (засах) ----------
    def update_item(item_id: int, body: model):  # type: ignore[valid-type]
        data = body.model_dump()
        q = sql.SQL("UPDATE {} SET {} WHERE {} = %s").format(
            tbl,
            sql.SQL(", ").join(sql.SQL("{} = %s").format(sql.Identifier(c)) for c in columns),
            idc,
        )
        try:
            with get_connection() as conn:
                cur = conn.execute(q, [data[c] for c in columns] + [item_id])
                if cur.rowcount == 0:
                    raise HTTPException(404, not_found_message)
                return _fetch_one(conn, item_id)
        except psycopg.Error as e:
            _db_error(e)

    app.put(f"{path}/{{item_id}}", dependencies=[Depends(auth)], name=f"update_{table}")(update_item)

    # ---------- DELETE (устгах) ----------
    def delete_item(item_id: int):
        try:
            with get_connection() as conn:
                if in_use_sql:
                    n = list(conn.execute(in_use_sql, (item_id,)).fetchone().values())[0]
                    if n > 0:
                        raise HTTPException(409, in_use_message.format(n=n))
                q = sql.SQL("DELETE FROM {} WHERE {} = %s").format(tbl, idc)
                if conn.execute(q, (item_id,)).rowcount == 0:
                    raise HTTPException(404, not_found_message)
            return {"deleted": item_id}
        except psycopg.Error as e:
            _db_error(e, deleting=True)

    app.delete(f"{path}/{{item_id}}", dependencies=[Depends(auth)], name=f"delete_{table}")(delete_item)
