FROM node:16.20.2-alpine3.17 as runner
RUN apk update && \
    apk upgrade && \
    apk add openrc && \
    apk add git

#RUN apk add make=4.2.1-r2
#RUN apk add g++=8.3.0-r0

RUN git clone https://github.com/formio/formio.git /formio
WORKDIR /formio
RUN yarn
ENV DEBUG=""

# This will initialize the application based on
# some questions to the user (login email, password, etc.)
ENTRYPOINT [ "node", "main" ]

