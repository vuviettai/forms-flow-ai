# base image
FROM node:16.20.1-alpine
#FROM node:18.17.1-alpine3.18
# set working directory
WORKDIR /micro-front-ends

# add `/app/node_modules/.bin` to $PATH
ENV PATH /micro-front-ends/forms-flow-admin/node_modules/.bin:$PATH
ENV PATH /micro-front-ends/forms-flow-nav/node_modules/.bin:$PATH
ENV PATH /micro-front-ends/forms-flow-service/node_modules/.bin:$PATH
ENV PATH /micro-front-ends/forms-flow-theme/node_modules/.bin:$PATH
ENV PATH /micro-front-ends/forms-flow-web/node_modules/.bin:$PATH

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh nginx
COPY frontend.nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]