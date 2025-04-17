FROM node:8.17-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine

# Instala bash y otras herramientas necesarias
RUN apk add --no-cache bash

# Copia el archivo de plantilla de nginx
COPY nginx.conf /etc/nginx/templates/nginx.conf.template  

# Copia el script para reemplazar variables
COPY replace-vars.sh /usr/local/bin/replace-vars.sh
RUN chmod +x /usr/local/bin/replace-vars.sh

# Copia archivos estáticos desde el build de Vue
COPY --from=build-stage /app/dist /usr/share/nginx/html

# CMD para ejecutar el script de reemplazo con la variable de entorno
CMD ["/bin/sh", "-c", "/usr/local/bin/replace-vars.sh \"$VUE_APP_PROXY_URL\" && envsubst '${AUTH_API_URL} ${TODOS_API_URL}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
