FROM ghcr.io/navikt/mock-oauth2-server:2.0.1

COPY ./config.json ./config.json

ENV JSON_FILE_PATH ./config.json
ENV SERVER_PORT 8090
