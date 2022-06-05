# 1. For build React app
FROM node:alpine AS development

# Set working directory
WORKDIR /usr/src/app

# Copy frontend
COPY frontend/ ./frontend/
RUN cd frontend && npm install
RUN cd frontend && npm audit fix --audit-level=critical
RUN cd frontend && npm run build

# 2. For Nginx setup
FROM nginx:alpine

# Copy nginx config
COPY /nginx/nginx.conf /etc/nginx/nginx.conf

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy nginx
COPY --from=development /usr/src/app/frontend/build/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# 3. Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
