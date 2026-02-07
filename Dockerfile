# 1. Imagen base de Python con Alpine
FROM python:3.13-alpine

# 2. Configuración para que Python no dé problemas en Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Definimos dónde vivirá la app
WORKDIR /app

# 4. Instalamos herramientas de Linux necesarias
# Tip de Analista: Se mantienen las librerías necesarias para compilar paquetes
RUN apk add --no-cache gcc musl-dev linux-headers libffi-dev python3-dev

#    postgresql-dev  # Por si en el futuro pasas de SQLite a Postgres

# 5. Instalamos tus librerías
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt --root-user-action=ignore

# 6. Copiamos todo tu código al contenedor
COPY . /app/

# 7. Creamos la carpeta de estáticos para que no haya problemas de permisos
RUN mkdir -p /app/staticfiles

# 8. Puerto por defecto
EXPOSE 8000

# 9. Comando por defecto (Opcional, ya que el Compose lo sobreescribe)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mi_proyecto.wsgi:application"]
