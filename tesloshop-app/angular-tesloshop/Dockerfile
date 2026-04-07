# ─────────────────────────────────────────────
# ETAPA 1: build
# Usa Node para compilar la aplicación Angular.
# Resultado: archivos estáticos en dist/.
# ─────────────────────────────────────────────
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ─────────────────────────────────────────────
# ETAPA 2: runtime
# Imagen final: solo Nginx + archivos estáticos.
# ─────────────────────────────────────────────
FROM nginx:alpine

COPY --from=build /app/dist/teslo-shop/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
