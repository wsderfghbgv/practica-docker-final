#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Deteniendo TesloShop..."
if docker compose version > /dev/null 2>&1; then
    docker compose down
else
    docker-compose down
fi

echo ""
echo "TesloShop detenido"
echo ""
echo "Para eliminar también los volúmenes (base de datos):"
echo "   docker compose down -v"
echo ""
