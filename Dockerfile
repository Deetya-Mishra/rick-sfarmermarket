# Simple multi-stage Dockerfile for Node-based web apps (React / Next / Express)
# Adjust NODE_VERSION, build/start commands as needed.

FROM node:18-alpine AS builder
WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm ci --silent

# Copy source and build
COPY . .

# If Next.js use: npm run build
# If CRA or static site use: npm run build (produces /build)
RUN npm run build

# Production image
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# If your app is static, you can serve with a lightweight server (nginx/caddy) instead.
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production --silent

# Copy build output and server code (if any)
COPY --from=builder /app ./

# Adjust the start command to your app (e.g., `npm start`, `node server.js`, or `npx serve -s build`)
CMD ["npm", "start"]
