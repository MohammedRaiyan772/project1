FROM nginx:1.27-alpine

# Copy the static website into the default Nginx web root.
COPY . /usr/share/nginx/html/

EXPOSE 80

# Nginx runs in the foreground as the container's main process.
CMD ["nginx", "-g", "daemon off;"]
