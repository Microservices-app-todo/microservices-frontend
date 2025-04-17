#!/bin/bash

# Verificar que se haya pasado la URL como parámetro
if [ -z "$1" ]; then
  echo "Uso: $0 <nueva_url>"
  exit 1
fi

# Parámetros
new_url="$1"
auth_file="src/auth.js"
todos_file="src/components/Todos.vue"
zipkin_file="src/zipkin.js"

# Reemplazar LOGIN_URL en auth.js sin importar su valor actual
sed -i "s|^\(const LOGIN_URL = \).*|\1'$new_url'|" "$auth_file"

# Reemplazar proxyUrl en Todos.vue sin importar su valor actual
sed -i "s|^\( *proxyUrl: \).*|\1'$new_url',|" "$todos_file"

# Reemplazar ZIPKIN_URL en zipkin.js sin importar su valor actual
sed -i "s|^\(const ZIPKIN_URL = \).*|\1'$new_url'|" "$zipkin_file"

echo "LOGIN_URL, proxyUrl y ZIPKIN_URL han sido actualizados a: $new_url"
