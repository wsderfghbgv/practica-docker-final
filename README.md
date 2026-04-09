# TesloShop — Contenerización con Docker y Docker Compose

Aplicación **end-to-end**: **Angular 19** (frontend), **NestJS** (API) y **PostgreSQL 14.3** (base de datos), orquestada con Docker Compose.

## Arquitectura

```mermaid
flowchart TB
  subgraph Host["Host"]
    Browser["Navegador"]
    subgraph DockerNet["Red: teslo-network"]
      FE["frontend\nNginx + Angular :80"]
      BE["backend\nNestJS :3000"]
      DB[("db\nPostgreSQL :5432")]
    end
  end
  Browser -->|"HTTP"| FE
  Browser -.->|"opcional"| BE
  FE -->|"/api, /socket.io"| BE
  BE --> DB
```

- El **navegador** accede al frontend en el puerto publicado (por defecto `80`). Nginx hace de **proxy inverso** hacia `backend:3000` para `/api` y `/socket.io`, evitando problemas de CORS en uso normal.
- Dentro de Compose, los servicios se resuelven por **nombre** (`db`, `backend`, `frontend`), no por `localhost`.
- El backend usa `DB_HOST=db` (nombre del servicio PostgreSQL).

Orden de arranque: **db** (con `healthcheck` hasta que Postgres acepte conexiones) → **backend** (`depends_on: service_healthy`) → **frontend** (`depends_on: backend`).

## Estructura del repositorio

| Ruta | Descripción |
| --- | --- |
| `docker-compose.yml` | Servicios `db`, `backend`, `frontend`, red y volumen de datos |
| `.env.example` | Plantilla de variables; copiar a `.env` |
| `start.sh` / `stop.sh` | Arranque y parada con `docker compose` |
| `teslo-shop/` | Backend NestJS y `Dockerfile` (etapas `dev` y `prod`) |
| `angular-tesloshop/` | Frontend Angular, `Dockerfile` (build + Nginx) y `nginx.conf` |

## Requisitos

- Docker Engine y Docker Compose v2 (`docker compose`).
- Puertos libres según `.env` (por defecto `80`, `3000`, `5432`).

## Pasos de ejecución

1. **Variables de entorno**

   ```bash
   cp .env.example .env
   ```
   <img width="870" height="108" alt="image" src="https://github.com/user-attachments/assets/96cd6df9-ae4a-46d3-8135-a25ef6d6db97" />







   Edita `.env` y unifica al menos: `POSTGRES_PASSWORD`, `DB_PASSWORD` (mismo valor) y `JWT_SECRET`.

1. **Permisos de los scripts** (Linux/macOS)

   ```bash
   chmod +x start.sh stop.sh
   ```
   <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/b94add44-f746-4094-9f97-910f36f06278" />

   <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/0c818e99-2c38-4820-9914-1be7ca0f912b" />



2. **Levantar el stack**

   ```bash
   ./start.sh
   ```
      <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/b94add44-f746-4094-9f97-910f36f06278" />
   

   O directamente:

   ```bash
   docker compose up --build -d
   ```
   <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/aafb348b-4eca-4ef2-bdd6-d62ee9eabf74" />


3. **Poblar datos de prueba** (primera vez)

   - Navegador: `http://localhost:3000/api/seed` (ajusta el host/puerto si cambiaste `BACKEND_PUBLISH_PORT`).
   - O: `curl http://localhost:3000/api/seed`
   - <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/70c31f67-ae8e-4c25-b7b1-28c43eb36a1f" />


4. **Probar la aplicación**

   | Recurso | URL típica |
   | --- | --- |
   | Frontend | `http://localhost` (o el puerto de `FRONTEND_PUBLISH_PORT`) |
   | API | `http://localhost:3000/api` |
   | Swagger | Documentación expuesta bajo el prefijo global `api` del backend |

   <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/5cdd290c-20c0-4493-b6c4-d9d1ced41a3c" />

   <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/70c31f67-ae8e-4c25-b7b1-28c43eb36a1f" />


6. **Ver logs**

   ```bash
   docker compose logs -f
   <img width="922" height="209" alt="image" src="https://github.com/user-attachments/assets/2629f9d5-e9c2-4cba-9759-83b112e13727" />

   docker compose logs -f backend
   ```
   <img width="922" height="209" alt="image" src="https://github.com/user-attachments/assets/6fdda40c-48c2-4b97-8287-8c14d2bf8b4d" />


7. **Detener**

   ```bash
   ./stop.sh
   ```
    <img width="842" height="277" alt="image" src="https://github.com/user-attachments/assets/0c818e99-2c38-4820-9914-1be7ca0f912b" />

   Datos de Postgres se conservan en el volumen `postgres-data`. Para borrar también la base:

   ```bash
   docker compose down -v
   ```
   <img width="922" height="209" alt="image" src="https://github.com/user-attachments/assets/2c18f3a9-55d4-48fe-a7b5-af7b30ac2257" />


## Servicios en `docker-compose.yml`

| Servicio | Imagen / build | Rol |
| --- | --- | --- |
| **db** | `postgres:14.3` | Base de datos; volumen persistente; `healthcheck` con `pg_isready` |
| **backend** | `./teslo-shop` (etapa `${STAGE}`) | API NestJS; en `dev` se monta el código y un volumen anónimo en `/app/node_modules` |
| **frontend** | `./angular-tesloshop` | Nginx sirve el build estático y proxifica `/api` y `/socket.io` |



GFPI-F-135 V04 — Laboratorio práctica final: contenerización end-to-end.
