FROM node:14-alpine as build-stage
WORKDIR /app

# Copiar los archivos de dependencias primero
COPY package*.json ./
RUN npm install  # Instalar las dependencias

# Copiar el resto de los archivos del proyecto
COPY . .

# Construir el proyecto
RUN npm run build

# Usar una imagen base ligera para producción
FROM nginx:alpine

# Instalar bash para poder usar envsubst
RUN apk add --no-cache bash

# Copiar el archivo de configuración de nginx
COPY nginx.conf /etc/nginx/templates/nginx.conf.template

# Copiar la carpeta construida desde el contenedor anterior
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Comando para ejecutar nginx
CMD ["/bin/sh", "-c", "envsubst '${AUTH_API_URL} ${TODOS_API_URL}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
