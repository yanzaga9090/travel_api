# ---------------------------------------------------------------
#  Travel Backend — AWS (App Runner / ECS / Elastic Beanstalk)
#
#  Нууц мэдээлэл (DATABASE_URL, JWT_SECRET ...) image дотор ОРОХГҮЙ.
#  AWS дээр орчны хувьсагчаар (эсвэл Secrets Manager-ээр) өгнө.
# ---------------------------------------------------------------
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=8000 \
    MODEL_PATH=models/demand_model.joblib

WORKDIR /app

# Эхлээд зөвхөн requirements → код өөрчлөгдөхөд сангуудыг дахин суулгахгүй (хурдан build)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Аппын код ба загвар
COPY main.py crud.py ./
COPY models/ ./models/

# root биш энгийн хэрэглэгчээр ажиллуулна (аюулгүй)
RUN useradd --create-home --uid 10001 appuser
USER appuser

EXPOSE 8000

# Сервер амьд эсэхийг AWS өөрөө шалгана: App Runner / ECS-ийн health check-д
# "/health" замыг (HTTP) зааж өгнө үү.

# --proxy-headers: AWS load balancer-ийн ард жинхэнэ IP, https-ийг зөв таних
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT} --proxy-headers --forwarded-allow-ips='*'"]
