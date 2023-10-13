# Production stage
FROM nginx:1.25.2-alpine as production-stage
RUN apk update && apk upgrade && apk add --no-cache tar bash
# Set label for image
LABEL Name="formsflow"

# Create directories
RUN mkdir -p /usr/share/nginx/html/root
RUN mkdir -p /usr/share/nginx/html/client
WORKDIR /usr/share/nginx/html

# Copy built files from build stage
COPY dist/root-config.tar.gz /tmp/root-config.tar.gz 
COPY dist/smartform-client.tar.gz /tmp/smartform-client.tar.gz
RUN tar -xvf /tmp/root-config.tar.gz -C /usr/share/nginx/html/root
RUN tar -xvf /tmp/smartform-client.tar.gz -C /usr/share/nginx/html/client
COPY docker/env.sh /usr/share/nginx/html/root/config
COPY docker/env.sh /usr/share/nginx/html/client/config
# Copy nginx configuration
# COPY docker/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 8080

# Set execute permission for env.sh
RUN chmod +x /usr/share/nginx/html/root/config/env.sh
RUN chmod +x /usr/share/nginx/html/client/config/env.sh
# Start Nginx server with environment setup
#CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/root/config/env.sh && /usr/share/nginx/html/client/config/env.sh && nginx -g 'daemon off;'"]