# Node builder
FROM node:16.20.2-alpine3.17 as builder
# Install necessary packages
RUN apk update && apk upgrade && apk add --no-cache git

RUN git clone https://github.com/vuviettai/smartform-client.git /smartform-client
# Set working directory
WORKDIR /smartform-client
COPY smartformclient.env /smartform-client/.env
ENV NODE_OPTIONS --max-old-space-size=8192

RUN yarn
RUN yarn build

WORKDIR /smartform-client/dist
RUN tar -zcvf /tmp/smartform-client.tar.gz .

FROM scratch AS export-stage
COPY --from=builder /tmp/smartform-client.tar.gz .
