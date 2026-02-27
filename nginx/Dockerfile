FROM nginx:stable-alpine3.23

# 1. Actualización de seguridad (Parchamos el CVE que detectó SSL Labs)
RUN apk add --no-cache openssl ca-certificates

# 2. Permisos de Archivos
# Nos aseguramos de que el usuario 'nginx' tenga acceso a los logs y caché
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx
