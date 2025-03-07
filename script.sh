#!/bin/bash

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Error: Docker no está instalado. Por favor, instálalo y vuelve a intentarlo."
    exit 1
fi

# Definir variables
IMAGE_NAME="node-app"
CONTAINER_NAME="node-app-container"
PORT=3000
NODE_ENV=production

# Construir la imagen de Docker
echo "Construyendo la imagen Docker..."
docker build -t $IMAGE_NAME .
if [ $? -ne 0 ]; then
    echo "Error: La construcción de la imagen falló."
    exit 1
fi

# Detener y eliminar el contenedor si ya está en ejecución
docker rm -f $CONTAINER_NAME 2>/dev/null

# Ejecutar el contenedor
echo "Ejecutando el contenedor..."
docker run -d --name $CONTAINER_NAME -p $PORT:3000 -e PORT=$PORT -e NODE_ENV=$NODE_ENV $IMAGE_NAME
if [ $? -ne 0 ]; then
    echo "Error: No se pudo iniciar el contenedor."
    exit 1
fi

# Esperar unos segundos para asegurar que el servicio esté disponible
sleep 5

# Verificar si el servicio responde
echo "Verificando el servicio..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/health)
if [ "$HTTP_STATUS" == "200" ]; then
    echo "Éxito: El servicio está funcionando correctamente en http://localhost:$PORT"
else
    echo "Error: El servicio no respondió correctamente (Código HTTP: $HTTP_STATUS)"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Imprimir resumen
echo "Despliegue exitoso. Contenedor '$CONTAINER_NAME' en ejecución."
