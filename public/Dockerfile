# syntax=docker/dockerfile:1.4

# Declare build args
ARG BUILDPLATFORM
ARG TARGETPLATFORM

# Build stage
FROM --platform=${BUILDPLATFORM:-linux/amd64} node:18-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies with legacy peer deps
RUN npm ci --legacy-peer-deps

# Copy source code
COPY . .

# Build the application
RUN npm run build


# Production stage
FROM --platform=${TARGETPLATFORM:-linux/amd64} node:18-slim

WORKDIR /app

# Install CA certificates and other necessary packages
RUN apt-get update && apt-get install -y ca-certificates openssl wget && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package*.json ./

# Install ALL dependencies, not just production ones
RUN npm ci --legacy-peer-deps

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Copy .env files
COPY .env ./.env

# Set environment variables
ENV NODE_ENV=production

# Expose the port your app runs on
EXPOSE 3000

# Start the application
CMD ["node", "dist/agent.js", "start"]



# # Error for this one because gcp says that BUILDPLATFORM is NOT Defined
# FROM --platform=$BUILDPLATFORM node:18-slim AS builder

# WORKDIR /app

# # Install build dependencies
# RUN apt-get update && apt-get install -y python3 make g++

# # Copy package files
# COPY package*.json ./

# # Install dependencies with legacy peer deps
# RUN npm ci --legacy-peer-deps

# # Copy source code
# COPY . .

# # Build the application
# RUN npm run build

# # Production stage
# FROM --platform=$TARGETPLATFORM node:18-slim

# WORKDIR /app

# # Install CA certificates and other necessary packages
# RUN apt-get update && apt-get install -y ca-certificates openssl wget && \
#     update-ca-certificates && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # Copy package files
# COPY package*.json ./

# # Install ALL dependencies, not just production ones
# RUN npm ci --legacy-peer-deps

# # Copy built application from builder stage
# COPY --from=builder /app/dist ./dist

# # Copy .env files
# COPY .env.local ./.env.local
# COPY .env ./.env

# # Set environment variables
# ENV NODE_ENV=production

# # Expose the port your app runs on
# EXPOSE 3000

# # Start the application
# CMD ["node", "dist/agent.js", "start"]

# # syntax=docker/dockerfile:1
# FROM node:20-slim

# # Create a non-privileged user
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/home/appuser" \
#     --shell "/sbin/nologin" \
#     --uid "${UID}" \
#     appuser

# WORKDIR /app

# # Copy only necessary files (package.json, package-lock.json)
# COPY package*.json ./
# COPY tsconfig.json ./

# # Install all dependencies including dev dependencies
# RUN npm install --legacy-peer-deps

# # Copy the rest of the application
# COPY . .

# # Build TypeScript code
# RUN npm run build

# # Clean up by removing devDependencies while keeping the legacy-peer-deps flag
# RUN npm prune --omit=dev --legacy-peer-deps

# # Switch to non-root user
# USER appuser

# # Expose the port your app runs on (If needed for web server)
# EXPOSE 3000

# # Start in production mode
# CMD ["node", "dist/agent.js", "start"]
