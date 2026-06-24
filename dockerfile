# --- Compilation Build Layer ---
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .

# --- Minimalistic Runtime Layer ---
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/src ./src
EXPOSE 5000
USER node
ENV NODE_ENV=production
CMD ["node", "src/server.js"]