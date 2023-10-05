# Base image
FROM node:14.17.6-alpine as build-stage

# Install necessary packages
RUN apk update && apk upgrade && apk add --no-cache curl git

RUN git clone https://github.com/vuviettai/forms-flow-ai.git /smartform
# Set working directory
WORKDIR /smartform/forms-flow-web-root-config

# Set build arguments
ARG NODE_ENV
ARG MF_FORMSFLOW_WEB_URL
ARG MF_FORMSFLOW_NAV_URL
ARG MF_FORMSFLOW_SERVICE_URL
ARG MF_FORMSFLOW_ADMIN_URL
ARG MF_FORMSFLOW_THEME_URL

# Set environment variables
ENV MF_FORMSFLOW_WEB_URL ${MF_FORMSFLOW_WEB_URL}
ENV MF_FORMSFLOW_NAV_URL ${MF_FORMSFLOW_NAV_URL}
ENV MF_FORMSFLOW_SERVICE_URL ${MF_FORMSFLOW_SERVICE_URL}
ENV MF_FORMSFLOW_ADMIN_URL ${MF_FORMSFLOW_ADMIN_URL}
ENV MF_FORMSFLOW_THEME_URL ${MF_FORMSFLOW_THEME_URL}
ENV NODE_ENV ${NODE_ENV:-production}

#ENV MF_FORMSFLOW_WEB_URL ${MF_FORMSFLOW_WEB_URL:-https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-web.gz.js}
#ENV MF_FORMSFLOW_NAV_URL ${MF_FORMSFLOW_NAV_URL:-https://forms-flow-microfrontends.aot-technologies.com/forms-flow-nav@v5.3.0-alpha/forms-flow-nav.gz.js}
#ENV MF_FORMSFLOW_SERVICE_URL ${MF_FORMSFLOW_SERVICE_URL:-https://forms-flow-microfrontends.aot-technologies.com/forms-flow-service@v5.3.0-alpha/forms-flow-service.gz.js}
#ENV MF_FORMSFLOW_ADMIN_URL ${MF_FORMSFLOW_ADMIN_URL:-https://forms-flow-microfrontends.aot-technologies.com/forms-flow-admin@v5.3.0-alpha/forms-flow-admin.gz.js}
#ENV MF_FORMSFLOW_THEME_URL ${MF_FORMSFLOW_THEME_URL:-https://forms-flow-microfrontends.aot-technologies.com/forms-flow-theme@v5.3.0-alpha/forms-flow-theme.gz.js}

ENV MF_FORMSFLOW_WEB_URL ${MF_FORMSFLOW_WEB_URL:-/forms-flow-web.js}
ENV MF_FORMSFLOW_NAV_URL ${MF_FORMSFLOW_NAV_URL:-/forms-flow-nav.js}
ENV MF_FORMSFLOW_SERVICE_URL ${MF_FORMSFLOW_SERVICE_URL:-/forms-flow-service.gz.js}
ENV MF_FORMSFLOW_ADMIN_URL ${MF_FORMSFLOW_ADMIN_URL:-/forms-flow-admin.js}
ENV MF_FORMSFLOW_THEME_URL ${MF_FORMSFLOW_THEME_URL:-/forms-flow-theme.gz.js}

# Add `/app/node_modules/.bin` to $PATH
ENV PATH /smartform/forms-flow-web-root-config/node_modules/.bin:$PATH

RUN npm ci --only=production

# Build the application
RUN if [ $NODE_ENV == "development" ]; then \
    npm run build-dev:webpack; \
    else \
    npm run build:webpack; \
    fi
WORKDIR /smartform/forms-flow-web-root-config/dist
#RUN curl -L "https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-web.gz.js" -o forms-flow-web.gz.js
#RUN curl -L "https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-nav.gz.js" -o forms-flow-nav.gz.js
#RUN curl -L "https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-service.gz.js" -o forms-flow-service.gz.js
#RUN curl -L "https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-admin.gz.js" -o forms-flow-admin.gz.js
#RUN curl -L "https://forms-flow-microfrontends.aot-technologies.com/forms-flow-web@v5.3.0-alpha/forms-flow-theme.gz.js" -o forms-flow-theme.gz.js
#ADD env.sh config/env.sh
ADD microfrontends/forms-flow-web.js forms-flow-web.js
ADD microfrontends/forms-flow-nav.js forms-flow-nav.js
ADD microfrontends/forms-flow-service.gz.js forms-flow-service.gz.js
ADD microfrontends/forms-flow-admin.js forms-flow-admin.js
ADD microfrontends/forms-flow-theme.gz.js forms-flow-theme.gz.js
RUN tar -zcvf /tmp/root-config.tar.gz .


FROM scratch AS export-stage
COPY --from=build-stage /tmp/root-config.tar.gz .
