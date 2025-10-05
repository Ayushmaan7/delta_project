# -----------------------------
# Stage 1: Build dependencies
# -----------------------------
FROM node:20.11.1-alpine AS builder

WORKDIR /app

# Copy package files first (leverage caching)
COPY package*.json ./

# Install dependencies (no dev deps needed for production)
RUN npm install --production

# -----------------------------
# Stage 2: Runtime image
# -----------------------------
FROM node:20.11.1-alpine

WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules

# Copy all project files
COPY . .

# Set environment to production
ENV NODE_ENV=production

# Expose the app port
EXPOSE 8080

# Start the app
CMD ["node", "app.js"]

