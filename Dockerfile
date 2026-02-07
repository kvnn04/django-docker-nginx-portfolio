# 1. Imagen base
FROM python:3.13-alpine

# 2. Configuración de Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Definimos directorio de trabajo
WORKDIR /app

# 4. Instalamos herramientas necesarias y creamos usuario de seguridad
# Creamos un usuario llamado 'django_user' para no correr como root
RUN apk add --no-cache gcc musl-dev linux-headers libffi-dev python3-dev \
    && adduser -D django_user

# 5. Instalamos librerías
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt --root-user-action=ignore

# 6. Copiamos el código
COPY . /app/

# 7. Creamos carpeta de estáticos y ajustamos permisos
# Es vital que el usuario sea dueño de la carpeta donde Django pondrá archivos
RUN mkdir -p /app/staticfiles && \
    chown -R django_user:django_user /app

# 8. CAMBIO CLAVE: Cambiamos al usuario sin privilegios
USER django_user

# 9. Puerto
EXPOSE 8000

# 10. Comando (Asegúrate de cambiar 'mi_proyecto' por el nombre real de tu carpeta)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mi_proyecto.wsgi:application"]
