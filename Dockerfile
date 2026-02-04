# --- Stage 1: Build the Vue.js Application ---
FROM node:18-alpine as build-stage

# Set the working directory inside the container
WORKDIR /app

# Copy package definition files first to leverage Docker cache
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the application for production (outputs to /dist folder)
RUN npm run build

# --- Stage 2: Serve with Nginx ---
# We use a lightweight Nginx image to serve static files
FROM nginx:alpine as production-stage

# Copy the built artifacts from the previous stage to Nginx directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
