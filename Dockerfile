# 1. Imagen base de Python con Alpine
FROM python:3.13-alpine

# 2. Configuración para que Python no de problemas en Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Definimos dónde vivirá la app
WORKDIR /app

# 4. Instalamos herramientas de Linux necesarias
# Tip de Analista: Agregamos postgresql-dev si usas Postgres más adelante
RUN apk add --no-cache gcc musl-dev linux-headers libffi-dev

# 5. Instalamos tus librerías
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiamos todo tu código al contenedor
COPY . /app/

# 7. Puerto por defecto
EXPOSE 8000

# 8. Comando para arrancar el servidor (CORREGIDO)
# Cambiamos "servidor_portfolio" por "mi_proyecto"
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mi_proyecto.wsgi:application"]
