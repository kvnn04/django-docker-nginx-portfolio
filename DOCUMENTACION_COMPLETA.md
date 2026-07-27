# Documentación Completa del Proyecto: Portfolio Personal

> **Proyecto:** django-docker-nginx-portfolio
> **Autor:** Kevin Herrera
> **URL:** https://kevinntech.com
> **Repositorio:** https://github.com/kvnn04/django-docker-nginx-portfolio

---

## Índice

1. [Descripción General](#1-descripción-general)
2. [Estructura del Proyecto](#2-estructura-del-proyecto)
3. [Arquitectura y Flujo](#3-arquitectura-y-flujo)
4. [Configuración de Infraestructura](#4-configuración-de-infraestructura)
   - 4.1 Dockerfile (Django)
   - 4.2 compose.yaml
   - 4.3 nginx/Dockerfile
   - 4.4 nginx/default.conf
5. [Backend Django](#5-backend-django)
   - 5.1 settings.py
   - 5.2 urls.py (raíz)
   - 5.3 main App (views, urls, templates)
   - 5.4 proyectos App (views, urls, templates)
6. [Frontend / Templates](#6-frontend--templates)
   - 6.1 base.html
   - 6.2 index.html
   - 6.3 Templates de proyectos
7. [Archivos Estáticos](#7-archivos-estáticos)
8. [CI/CD](#8-cicd)
9. [Dependencias](#9-dependencias)
10. [Problemas Conocidos](#10-problemas-conocidos)
11. [Curriculum Vitae (Kevin Herrera)](#11-curriculum-vitae)

---

## 1. Descripción General

Portfolio web profesional de **Kevin Herrera** (Desarrollador Full Stack & Estudiante de Análisis de Sistemas), construido con Django 6.0 y desplegado con una arquitectura de producción basada en Docker + Nginx + Gunicorn.

### Funcionalidades

- Página de inicio con presentación profesional, perfil, stack tecnológico, experiencia laboral, educación, certificaciones y sección "Sobre mí"
- 6 páginas de portfolio de proyectos (Base de Datos, Backend, Frontend, Fullstack, DevOps, Redes)
- Footer con enlaces a LinkedIn, GitHub y Email
- Botón de descarga de CV en PDF
- Diseño responsive con Bootstrap 5.3

### Tecnologías Principales

| Componente | Tecnología |
|---|---|
| Backend Framework | Django 6.0.1 (Python 3.13) |
| WSGI Server | Gunicorn 25.0.1 |
| Web Server / Proxy | Nginx (stable-alpine3.23) |
| Contenerización | Docker + Docker Compose |
| Base de Datos | SQLite (desarrollo) |
| Frontend | Bootstrap 5.3, CSS3, Bootstrap Icons |
| SSL | Let's Encrypt |
| CI/CD | GitHub Actions → AWS |
| SO Desarrollo | WSL2 (Ubuntu) |

---

## 2. Estructura del Proyecto

```
django-docker-nginx-portfolio/
├── .github/
│   └── workflows/
│       └── deploy.yml                  # CI/CD: Auto-deploy a AWS
├── .gitignore
├── compose.yaml                        # Orquestación Docker
├── Dockerfile                          # Imagen Django + Gunicorn
├── manage.py                           # Entry point Django
├── README.md                           # Documentación del proyecto
├── requirements.txt                    # Dependencias Python
├── DOCUMENTACION_COMPLETA.md           # Este archivo
│
├── mi_proyecto/                        # Django project package
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings.py                     # Configuración principal
│   ├── urls.py                         # Routing raíz
│   └── wsgi.py
│
├── main/                               # Django app: página principal
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── urls.py
│   ├── views.py
│   ├── migrations/
│   │   └── __init__.py
│   └── templates/main/
│       ├── base.html                   # Template base (navbar, footer)
│       └── index.html                  # Home page (perfil, exp, edu, certs)
│
├── proyectos/                          # Django app: portfolio de proyectos
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── urls.py
│   ├── views.py
│   ├── migrations/
│   │   └── __init__.py
│   └── templates/proyectos/
│       ├── backend.html                # Proyectos Backend
│       ├── base_de_datos.html          # Proyectos DB
│       ├── devops.html                 # Proyectos DevOps
│       ├── frontend.html               # Proyectos Frontend
│       ├── fullstack.html              # Proyectos Fullstack
│       └── redes.html                  # Proyectos Redes
│
├── nginx/                              # Configuración Nginx
│   ├── Dockerfile
│   └── default.conf                    # Proxy + SSL + Seguridad
│
└── static/                             # Archivos estáticos
    ├── css/
    │   └── style.css
    ├── img/
    │   └── kuma_bienvenida.png
    └── pdf/
        └── Kevin_Alexandro_Herrera.pdf # CV descargable
```

---

## 3. Arquitectura y Flujo

```
                    INTERNET
                        │
                        ▼
              ╔══════════════════╗
              ║     Nginx        ║
              ║  :80 (HTTP)      ║  → Redirección a HTTPS
              ║  :443 (HTTPS)    ║  → Proxy Inverso
              ╚══════════╤═══════╝
                         │
              ┌──────────┼──────────┐
              │          │          │
              ▼          ▼          ▼
        ┌──────────┐ ┌────────┐ ┌────────┐
        │ /static/ │ │ /      │ │ .well- │
        │ (alias)  │ │ proxy  │ │ known  │
        │ Archivos │ │ →      │ │ ACME   │
        │ estáticos│ │ Django │ │ (SSL)  │
        └──────────┘ └───┬────┘ └────────┘
                         │
                         ▼
              ╔══════════════════╗
              ║   Gunicorn       ║
              ║   :8000          ║
              ╚══════╤═══════════╝
                     │
                     ▼
              ╔══════════════════╗
              ║   Django App     ║
              ║  mi_proyecto     ║
              ╚══════╤═══════════╝
                     │
            ┌────────┴────────┐
            ▼                 ▼
      ┌──────────┐     ┌──────────┐
      │  main    │     │proyectos │
      │ (home,   │     │ (6 págs  │
      │  about,  │     │ portfolio│
      │  exp,    │     │          │
      │  edu,    │     │          │
      │  certs)  │     │          │
      └──────────┘     └──────────┘
```

### Flujo de una petición

1. Usuario visita `https://kevinntech.com`
2. Nginx recibe la petición en puerto 443 (SSL)
3. Nginx verifica certificados y cabeceras de seguridad
4. Si es `/static/` → Nginx sirve el archivo directamente del disco (offloading)
5. Si es otra ruta → Nginx hace `proxy_pass` a `http://repo_app:8000`
6. Gunicorn recibe la petición y la pasa a Django
7. Django resuelve la URL y ejecuta la view correspondiente
8. La view renderiza un template HTML y devuelve la respuesta
9. Gunicorn devuelve la respuesta a Nginx
10. Nginx envía la respuesta al cliente

---

## 4. Configuración de Infraestructura

### 4.1 Dockerfile (Django App)

```dockerfile
FROM python:3.13-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instala dependencias de compilación y crea usuario no-root
RUN apk add --no-cache gcc musl-dev linux-headers libffi-dev python3-dev \
    && adduser -D django_user

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt --root-user-action=ignore

COPY . /app/

RUN mkdir -p /app/staticfiles && \
    chown -R django_user:django_user /app

USER django_user

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mi_proyecto.wsgi:application"]
```

**Puntos clave:**
- Usa `python:3.13-alpine` para imagen liviana
- Crea usuario `django_user` (no-root) por seguridad
- Instala dependencias primero (caching de capas Docker)
- Cambia a usuario no-root antes de ejecutar

### 4.2 compose.yaml

```yaml
services:
  web:
    build: .
    container_name: portfolio
    command: >
      sh -c "python manage.py collectstatic --noinput &&
             gunicorn mi_proyecto.wsgi:application --bind 0.0.0.0:8000"
    volumes:
      - .:/app
      - static_volume:/app/staticfiles
    environment:
      - PYTHONUNBUFFERED=1
      - DEBUG=False
    env_file:
      - .env
    expose:
      - "8000"
    user: "1000:1000"

  nginx:
    build: ./nginx
    container_name: nginx_portfolio
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx:/etc/nginx/conf.d
      - static_volume:/app/staticfiles:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
      - ./logs/nginx:/var/log/nginx
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    depends_on:
      - web

volumes:
  static_volume:
```

**Puntos clave:**
- 2 servicios: `web` (Django) y `nginx` (proxy)
- Volumen compartido `static_volume` para archivos estáticos
- Nginx monta `./nginx` como conf.d (no como archivo único)
- Certificados Let's Encrypt montados como read-only
- Logs de Nginx persistidos en `./logs/nginx`

### 4.3 nginx/Dockerfile

```dockerfile
FROM nginx:stable-alpine3.23

RUN apk add --no-cache openssl ca-certificates

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx
```

**Puntos clave:**
- Usa `nginx:stable-alpine3.23`
- Parchea CVE de OpenSSL
- Corrige permisos para que nginx pueda escribir logs y caché

### 4.4 nginx/default.conf

```nginx
# --- CONFIGURACIÓN GLOBAL ---
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=1r/s;
limit_req_status 429;
server_tokens off;

upstream repo_app {
    server portfolio:8000;
}

# --- BLOQUE HTTPS (kevinntech.com) ---
server {
    listen 443 ssl default_server;
    server_name kevinntech.com;

    # SSL Certificates (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/kevinntech.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kevinntech.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/kevinntech.com/fullchain.pem;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # TLS 1.2/1.3 con ciphers fuertes
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:...";
    ssl_prefer_server_ciphers on;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header Content-Security-Policy "default-src 'none'; script-src 'self' https://cdn.jsdelivr.net; ..." always;

    # Rate limiting + proxy a Django
    location / {
        if ($query_string ~* "...") { return 403; }  # Anti-SSRF
        if ($request_method !~ ^(GET|HEAD|POST)$ ) { return 405; }
        limit_req zone=mylimit burst=5 nodelay;
        proxy_pass http://repo_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static files (offloading)
    location /static/ {
        alias /app/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    # Let's Encrypt ACME challenge
    location /.well-known/acme-challenge/ {
        root /usr/share/nginx/html;
    }
}

# --- REDIRECCIÓN HTTP → HTTPS ---
server {
    listen 80;
    server_name kevinntech.com;
    location / { return 301 https://kevinntech.com$request_uri; }
    location /.well-known/acme-challenge/ { root /usr/share/nginx/html; }
}
```

**Características de seguridad:**
- Rate limiting: 1 req/s por IP (burst 5)
- TLS 1.2/1.3 solamente
- HSTS preload
- Content Security Policy estricta
- Anti-exploit: bloquea `.env`, `.git`, shells PHP, etc.
- Anti-SSRF: bloquea metadata cloud, path traversal
- OCSP Stapling
- Server tokens off

---

## 5. Backend Django

### 5.1 settings.py (`mi_proyecto/settings.py`)

**Configuración clave:**
- `SECRET_KEY`, `DEBUG`, `ALLOWED_HOSTS` desde variables de entorno
- `USE_X_FORWARDED_HOST = True` (para funcionar detrás de proxy)
- `SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')`
- Apps instaladas: `main`, `proyectos`
- Base de datos: SQLite (local)
- `STATIC_URL = '/static/'`
- `STATICFILES_DIRS = [BASE_DIR / 'static']`
- `STATIC_ROOT = BASE_DIR / 'staticfiles'`
- Seguridad: `X_FRAME_OPTIONS = 'DENY'`, `SECURE_CONTENT_TYPE_NOSNIFF = True`, `SECURE_BROWSER_XSS_FILTER = True`, `SECURE_REFERRER_POLICY = "strict-origin-when-cross-origin"`

### 5.2 urls.py (raíz - `mi_proyecto/urls.py`)

```python
urlpatterns = [
    path('', include('main.urls')),
    path('proyectos/', include('proyectos.urls')),
]
```

### 5.3 main App

**views.py:**
```python
def home(request):
    return render(request, 'main/index.html')
```

**urls.py:**
```python
urlpatterns = [
    path('', views.home, name='home'),
]
```

**Templates:**
- `main/templates/main/base.html` - Template base con navbar y footer
- `main/templates/main/index.html` - Página principal completa

### 5.4 proyectos App

**views.py:**
```python
def lista_proyectos(request):
    return render(request=request, template_name='proyectos/backend.html')

def proyecto_database(request):
    return render(request=request, template_name='proyectos/base_de_datos.html')

def proyecto_backend(request):
    return render(request=request, template_name='proyectos/backend.html')

def proyecto_frontend(request):
    return render(request=request, template_name='proyectos/frontend.html')

def proyecto_fullstack(request):
    return render(request=request, template_name='proyectos/fullstack.html')

def proyecto_devops(request):
    return render(request=request, template_name='proyectos/devops.html')

def proyecto_redes(request):
    return render(request=request, template_name='proyectos/redes.html')
```

**urls.py:**
```python
urlpatterns = [
    path('', views.lista_proyectos, name='lista'),
    path('database', views.proyecto_database, name='base_de_datos'),
    path('backend', views.proyecto_backend, name='backend'),
    path('frontend', views.proyecto_frontend, name='frontend'),
    path('devops', views.proyecto_devops, name='devops'),
    path('fullstack', views.proyecto_fullstack, name='fullstack'),
    path('redes', views.proyecto_redes, name='redes'),
]
```

**Contenido de cada template de proyecto:**

| Ruta | Template | Proyectos Mostrados |
|---|---|---|
| `/proyectos/` | backend.html | API KHANTANI + DINERLESS |
| `/proyectos/database` | base_de_datos.html | E-commerce Data Architecture + API KHANTANI + DINERLESS DB |
| `/proyectos/backend` | backend.html | API KHANTANI (FastAPI) + DINERLESS (DRF) |
| `/proyectos/frontend` | frontend.html | KHANTANI E-commerce UI (Flask) |
| `/proyectos/fullstack` | fullstack.html | KHANTANI UI + API KHANTANI |
| `/proyectos/devops` | devops.html | Production-Ready Stack (Docker/Nginx/Django) |
| `/proyectos/redes` | redes.html | Guía OSI + Arquitectura TCP/IP |

---

## 6. Frontend / Templates

### 6.1 base.html (`main/templates/main/base.html`)

**Características:**
- Bootstrap 5.3 vía CDN (con integridad)
- Bootstrap Icons v1.11.3 vía CDN
- Navbar oscuro fijo con enlaces: Inicio, Proyectos, Sobre mí, Contacto
- Footer con: LinkedIn, GitHub, Email + copyright
- Bloque `{% block content %}` para herencia de templates
- Bloque `{% block title %}` para título personalizado

### 6.2 index.html (`main/templates/main/index.html`)

**Secciones (en orden):**
1. **Hero/Header**: Foto de perfil, nombre, título, bio profesional, botones (Portafolio, LinkedIn, Descargar CV)
2. **Zona de Laboratorios**: 6 cards de categorías de proyectos (Base de Datos, Back-End, Front-End, Fullstack, DevOps, Redes)
3. **Stack Tecnológico**:
   - Base de datos: SQL Server, MySQL, SQLite, PostgreSQL
   - Desarrollo Backend: Python/Django, Python/FastAPI, Python/Flask, C#/.NET, JavaScript, Flutter
   - Frontend: HTML5/CSS3, Bootstrap 5
   - Herramientas & Ofimática: VBA (Excel/Outlook), Git/GitHub
   - Sistemas, DevOps & Metodologías: Linux/Bash, Windows/PowerShell, Docker, Metodologías Ágiles
4. **Experiencia Laboral**: Efectivo Sí - Analista en Cobranzas Digitales (Feb 2025 – Jun 2026) con 5 logros detallados
5. **Educación**: Instituto Don Bosco (83%) + Instituto ALCAL (secundario técnico)
6. **Certificaciones**: 3 certificaciones IBM (Python for Data Science, Data Analysis, Data Visualization)
7. **Sobre mí**: Texto personal + tarjeta de información clave (teléfono, ubicación, formación, portfolio, disponibilidad)

### 6.3 Templates de proyectos

Cada template de proyecto sigue la misma estructura:
- Extiende `main/base.html`
- Título personalizado
- Grid de cards (1-3 proyectos por página)
- Cada card tiene: badge/logo, título, descripción, badges tecnológicos, lista de features, enlaces a GitHub y documentación

---

## 7. Archivos Estáticos

### static/css/style.css

CSS personalizado con:
- Variables CSS (colores primarios)
- Scroll suave
- Transiciones y hover effects en cards
- Estilos responsive para `.display-1`
- Timeline items (para experiencia laboral)
- Badges de certificaciones con gradiente
- Clases utilitarias (transition-base, skill-card, btn-social)

### static/img/kuma_bienvenida.png

Imagen decorativa (mascota/logo), usada (o referenciada) en el template.

### static/pdf/Kevin_Alexandro_Herrera.pdf

CV de Kevin Herrera en PDF, descargable desde el botón "Descargar CV" en el home.

---

## 8. CI/CD

### `.github/workflows/deploy.yml`

```yaml
name: Deploy Portfolio to AWS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Deploy to Server via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd ~/django-docker-nginx-portfolio
            git pull origin main
            docker compose up -d --build
            docker system prune -f
```

**Flujo del pipeline:**
1. Se activa en push a `main`
2. Hace checkout del código
3. Se conecta por SSH al servidor AWS
4. Navega al directorio del proyecto
5. Hace `git pull` para traer los cambios
6. Reconstruye y reinicia contenedores con `docker compose up -d --build`
7. Limpia imágenes Docker no usadas con `docker system prune -f`

**Secrets requeridos en GitHub:**
- `SERVER_IP` - IP del servidor AWS
- `SERVER_USER` - Usuario SSH
- `SSH_PRIVATE_KEY` - Clave privada SSH

---

## 9. Dependencias

### requirements.txt

```
asgiref==3.11.0
Django==6.0.1
gunicorn==25.0.1
packaging==26.0
python-dotenv==1.2.1
sqlparse==0.5.5
tzdata==2025.3
```

### Otras dependencias (sistema)
- Nginx (en contenedor Alpine)
- Bootstrap 5.3 (CDN)
- Bootstrap Icons 1.11.3 (CDN)

---

## 10. Problemas Conocidos

### 10.1 ~~Error 404 en `/proyectos/`~~ RESUELTO
- **Antes:** `lista_proyectos` apuntaba a `proyectos/lista.html` que no existía
- **Solución:** Se redirige a `proyectos/backend.html`

### 10.2 CSS placeholder
- **Antes:** `style.css` tenía solo 4 líneas placeholder
- **Solución:** Se completó con estilos reales (transiciones, hover effects, responsive, timeline, etc.)

### 10.3 Código comentado en fullstack.html
- **Antes:** Había código HTML comentado de proyectos anteriores
- **Solución:** Se limpió

### 10.4 Archivo `.env` faltante
- El `.env` con `SECRET_KEY`, `DEBUG`, `ALLOWED_HOSTS` debe existir en el servidor
- Está en `.gitignore` por seguridad

### 10.5 Puerto 80 bloqueado
- En Windows, el puerto 80 puede estar ocupado por IIS
- Solución documentada: mapear a puerto alternativo (8080)

### 10.6 Base de datos SQLite
- No es recomendable para producción real
- Para escalar, migrar a PostgreSQL (como se referencia en los proyectos)

---

## 11. Curriculum Vitae

### Kevin Herrera

**Contacto:**
- Teléfono: +54 11 5135-1658
- Email: kvnherrera.04@gmail.com
- LinkedIn: https://www.linkedin.com/in/kevin-herrera04
- GitHub: https://github.com/kvnn04
- Portfolio: https://kevinntech.com
- Ubicación: CABA, Buenos Aires, Argentina

### Perfil Profesional

Desarrollador de Software Full Stack y estudiante avanzado de Análisis de Sistemas (83% completado) con enfoque en el desarrollo de aplicaciones web, diseño de APIs REST, arquitectura de datos y automatización de procesos operativos. Combino competencia técnica con entendimiento del negocio financiero, optimizando flujos de información críticos, mitigando el riesgo operativo y maximizando la eficiencia.

### Proyectos Destacados

#### DINERLESS - Finance Engine & Database Architecture
- Arquitectura de base de datos relacional (PostgreSQL en 3NF)
- API REST modular con Django REST Framework
- Permisos granulares, resúmenes automatizados, JWT, OpenAPI 3.0

#### KHANTANI - E-commerce Engine & UI
- Backend escalable con FastAPI (Python 3.13), SOLID, GRASP, SQLAlchemy
- UI/UX con Flask y Bootstrap 5.3, autenticación JWT, carrito, Mercado Pago

#### Production-Ready Stack - Infraestructura & DevOps
- Arquitectura contenerizada con Docker Compose (Separation of Concerns)
- Proxy Inverso con Nginx, CI/CD automatizado con GitHub Actions en AWS

### Experiencia Laboral

**Efectivo Sí | Analista en Cobranzas Digitales**
Feb 2025 – Jun 2026 | Buenos Aires, Argentina
- Automatización del 70% del procesamiento manual de pagos (app web propia)
- Soluciones web para pagos de agencias externas y conciliación bancaria
- Integración Outlook/Excel con VBA para automatización de registros
- Optimización de procesos manuales y estandarización de datos
- Calibración de Agente de IA Conversacional para cobranzas

### Educación

| Institución | Título | Período |
|---|---|---|
| Instituto Superior Don Bosco Pío IX | Técnico Superior en Análisis de Sistemas (83%) | Mar 2024 – Presente |
| Instituto Sagrado Corazón ALCAL | Técnico en Programación en Software Libre | Mar 2016 – Dic 2022 |

### Habilidades Técnicas

| Categoría | Tecnologías |
|---|---|
| Lenguajes & Backend | C# (.NET), Python (Django, FastAPI), JavaScript, RESTful APIs, POO |
| Frontend & Mobile | HTML5, CSS3, JavaScript, Flutter |
| Bases de Datos | SQL Server, PostgreSQL, MySQL, SQLite |
| Herramientas & DevOps | Git, GitHub, Docker, Linux (Bash), VBA |
| Metodologías | Scrum, Análisis de Procesos, Integración de IA |

### Certificaciones

| Certificación | Institución | Año |
|---|---|---|
| Python for Data Science | IBM | 2023 |
| Data Analysis with Python | IBM | 2023 |
| Data Visualization with Python | IBM | 2023 |

---

*Documento generado el 27/07/2026 - Incluye todas las actualizaciones del portfolio.*
