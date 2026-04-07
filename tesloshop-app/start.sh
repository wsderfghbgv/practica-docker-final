#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

echo "Iniciando TesloShop..."
echo ""

if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker no está corriendo. Inicia el servicio de Docker."
    exit 1
fi

echo "Docker está corriendo"
echo ""

echo "Construyendo e iniciando contenedores..."
if docker compose version > /dev/null 2>&1; then
    docker compose up --build -d
else
    docker-compose up --build -d
fi

echo ""
echo "Esperando a que los servicios estén listos..."
sleep 10

echo ""
echo "TesloShop está corriendo!"
echo ""
echo "Accede a la aplicación:"
echo "   Frontend:      http://localhost:${FRONTEND_PUBLISH_PORT:-80}"
echo "   Backend API:   http://localhost:${BACKEND_PUBLISH_PORT:-3000}/api"
echo "   Base de datos: localhost:${POSTGRES_PUBLISH_PORT:-5432}"
echo ""
echo "Ver logs:"
echo "   docker compose logs -f"
echo ""
echo "Detener la aplicación:"
echo "   ./stop.sh   o   docker compose down"
echo ""
