FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
# This caches the dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the project files
COPY . .

# Run the build command defined in package.json
RUN npm run build

# --- Stage 2: Serve the static site ---
# Use a tiny, official NGINX image
FROM nginx:1.27-alpine-slim

# Copy the built site (from the 'build' stage) into NGINX's web root
COPY --from=build /app/dist /usr/share/nginx/html

# Tell Docker the container listens on port 80
EXPOSE 80

# The default command to start NGINX
CMD ["nginx", "-g", "daemon off;"]