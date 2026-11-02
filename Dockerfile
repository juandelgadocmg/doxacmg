# ==========================================
# Etapa 1: Construcción (Build Stage)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias del sistema necesarias si las hubiera
RUN apk add --no-cache libc6-compat

# Copiar manifiestos de paquetes
COPY package.json package-lock.json ./

# Instalar dependencias del proyecto
RUN npm install

# Copiar todo el código fuente
COPY . .

# Argumentos de construcción para variables de entorno de Vite
ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_PUBLISHABLE_KEY
ARG VITE_SUPABASE_PROJECT_ID

ENV VITE_SUPABASE_URL=${VITE_SUPABASE_URL}
ENV VITE_SUPABASE_PUBLISHABLE_KEY=${VITE_SUPABASE_PUBLISHABLE_KEY}
ENV VITE_SUPABASE_PROJECT_ID=${VITE_SUPABASE_PROJECT_ID}

# Compilar la aplicación para producción (genera la carpeta dist/)
RUN npm run build

# ==========================================
# Etapa 2: Servidor Nginx (Production Stage)
# ==========================================
FROM nginx:alpine AS runner

# Copiar la configuración personalizada de Nginx para SPA (React Router)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos compilados desde la etapa anterior
COPY --from=builder /app/dist /usr/share/nginx/html

# Puerto estándar para Coolify
EXPOSE 80

# Iniciar servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
