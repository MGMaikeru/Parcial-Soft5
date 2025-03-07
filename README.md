# ArquitecturaSFV-P1

# Evaluación Práctica - Ingeniería de Software V

## Información del Estudiante

- **Nombre: Miguel Gonzalez**
- **Código: A00395687**
- **Fecha: 07/03/2025**

## Resumen de la Solución

Se implementó un `Dockerfile` para la creación y depliegue un proyecto de node que expone dos APIs. Posteriormente se implemento un codigo de automatización en `script.sh`, que realiza el proceso de verificación de docker, construcción de la imagen, despliegue y comprobación de los servicios de la app, notificando al usuario de manera clara si se encontro algun error en los pasos anteriormente mencionados.

## Dockerfile

- Se usa la imagen oficial de Node.js versión 22 basada en Alpine Linux, que es una distribución ligera y las mas actual hasta la fecha. Esta imagen reduce el tamaño de la imagen final.
- Establece el directorio de trabajo dentro del contenedor en `\app` en donde todas las operaciones siguientes se ejecutarán, manteniendo ordenado el sistema de archivos del contenedor.
- Se copia el archivo package.json al directorio `/app` en el contenedor permitiendo instalar las dependencias antes de copiar el resto del código, optimizando el uso de la caché de Docker.
- Se instala las dependencias del proyecto, omitiendo las de desarrollo minimizando las dependencias dentro del contenedor.
- Se copia el resto del código fuente al contenedor. Se coloca después de npm install para aprovechar la caché de Docker.
- Se indica que el contenedor usará el puerto 3000 para recibir tráfico.
- Se define el comando de inicio del contenedor: Ejecuta `node .`, lo que significa que busca y ejecuta el `app.js` del proyecto.

## Script de Automatización

- Se Usa `command -v docker` para verificar si Docker está instalado. Si Docker no está disponible, muestra un mensaje de error y sale del script con `exit 1`.
- Se definen las variables de entorno:
  IMAGE_NAME: Nombre de la imagen Docker.
  CONTAINER_NAME: Nombre del contenedor para evitar nombres aleatorios.
  PORT: Define el puerto en el host (3000).
  NODE_ENV: Variable de entorno para definir que la aplicación se ejecuta en "production".
- se ejecuta `docker build -t node-app .` para construir la imagen con el nombre node-app. `if [ $? -ne 0 ]; then ...` verifica si el último comando (docker build) falló (`$?` almacena el código de salida). Si la construcción falla, se detiene el script con `exit 1`.
- se usa `docker rm -f node-app-container` para eliminar cualquier contenedor en ejecución con el mismo nombre. `2>/dev/null` silencia errores en caso de que el contenedor no exista.
- `docker run -d` ejecuta el contenedor en modo demonio (en segundo plano). `--name $CONTAINER_NAME` le da un nombre identificable. `-p $PORT:3000` mapea el puerto del host al contenedor. `-e PORT=$PORT -e NODE_ENV=$NODE_ENV` establece variables de entorno.
- se espera 5 segundos para que la aplicación dentro del contenedor tenga tiempo de arrancar.
- Se usa `curl` para hacer una petición HTTP a http://localhost:3000/health. La opción `-s -o /dev/null -w "%{http_code}"` obtiene el código HTTP de respuesta. Si la respuesta es 200, el despliegue fue exitoso. Si falla, imprime los logs del contenedor con `docker logs $CONTAINER_NAME` para ayudar a depurar el error.
- Si todo salió bien, imprime un mensaje indicando que el despliegue fue exitoso.

## Principios DevOps Aplicados

1. Automatización: En DevOps, se busca minimizar la intervención manual mediante la automatización de procesos repetitivos, como la construcción, el despliegue y la verificación de servicios. Usando el `script.sh` no es necesario hacer docker build, docker run o verificar manualmente la respuesta con curl, cumpliendo este principio.
2. IaaS: En DevOps, la infraestructura (servidores, contenedores, redes) debe definirse y gestionarse mediante código en lugar de configuraciones manuales. El script Bash maneja la ejecución del servicio como un entorno reproducible, permitiendo que cualquier persona pueda desplegar el servicio en cualquier entorno con Docker, ademas de eliminar el famoso "funciona en mi máquina", porque el mismo código funciona en cualquier sistema con Docker.
3. Monitorización y Feedback Rápido: DevOps enfatiza la monitorización continua y la obtención rápida de feedback para detectar problemas lo antes posible. El script usa curl para hacer una solicitud HTTP a /health y tambien detecta si la imagen no se construye bien. Reduciendo el tiempo de detección de fallos y permitiendo actuar rápidamente si el servicio no está funcionando correctamente.

## Captura de Pantalla

[Incluye al menos una captura de pantalla que muestre tu aplicación funcionando en el contenedor]

## Mejoras Futuras

[Describe al menos 3 mejoras que podrían implementarse en el futuro]

## Instrucciones para Ejecutar

[Instrucciones paso a paso para ejecutar tu solución]
