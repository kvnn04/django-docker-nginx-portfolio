# 🚀 Arquitectura de Despliegue: Django + Nginx + Docker

## 📝 Descripción del Proyecto
Implementación de un entorno de producción robusto para un portfolio web, utilizando **Docker** para la contenerización y **Nginx** como servidor de alto rendimiento y proxy inverso.

---

## 🧠 Aprendizajes Clave

### 1. Contenerización y Orquestación
* **Aislamiento de Entornos:** Uso de Docker para separar la lógica de aplicación (Django) de la capa de servidor web (Nginx), garantizando la portabilidad total del proyecto.
* **Docker Compose:** Gestión de multi-contenedores, redes internas y orquestación de volúmenes compartidos para la persistencia de datos.

### 2. Servidor Web y Proxy Inverso (Nginx)
* **Offloading de Estáticos:** Configuración optimizada para servir archivos CSS, JS e imágenes directamente desde el disco mediante `alias`, optimizando los recursos del servidor.
* **Proxy Inverso:** Redirección de peticiones externas (puerto 8080) hacia el servidor de aplicaciones interno (Gunicorn en puerto 8000).
* **Gestión de Upstreams:** Implementación de bloques `upstream` para una arquitectura escalable y limpia.

### 3. Resolución de Conflictos de Red (Networking)
* **Manejo de Puertos:** Resolución de colisiones con servicios del sistema (IIS/Windows), mediante el mapeo estratégico de puertos.
* **Protocolos IP:** Diagnóstico y resolución de diferencias entre IPv4 (`127.0.0.1`) e IPv6 (`::1`).
* **Headers HTTP:** Configuración de `X-Forwarded-Host` y `Host headers` para una correcta reconstrucción de URLs en Django.

---

## 🛠️ Stack Tecnológico Utilizado

| Componente | Tecnología | Rol |
| :--- | :--- | :--- |
| **App Server** | Django + Gunicorn | Lógica de negocio y procesamiento. |
| **Web Server** | Nginx (Alpine) | Proxy inverso y entrega de estáticos. |
| **Infraestructura** | Docker / Compose | Orquestación de contenedores. |
| **Entorno** | WSL2 (Ubuntu) | Sistema operativo de desarrollo. |

---

## 🔧 Desafíos Superados: Caso de Estudio

> **Reto:** Los archivos estáticos devolvían error 404 y el tráfico no llegaba al contenedor debido a que el puerto 80 estaba bloqueado por un proceso del sistema (ID 4).

**Solución aplicada:**
1.  **Diagnóstico:** Uso de logs de Nginx y herramientas de red (`netstat`, `Test-NetConnection`) para identificar el bloqueo.
2.  **Migración:** Reconfiguración del mapeo de puertos al **8080** para eludir el conflicto.
3.  **Sincronización:** Ajuste de `USE_X_FORWARDED_HOST` en Django para alinear la generación de URLs con el nuevo puerto de exposición.

---

## 💡 Reflexión Final
Este flujo de trabajo implementa el principio de **Separación de Responsabilidades (Separation of Concerns)**, mejorando drásticamente el rendimiento y preparando la aplicación para ser escalada en entornos cloud como **AWS, DigitalOcean o Azure**.
