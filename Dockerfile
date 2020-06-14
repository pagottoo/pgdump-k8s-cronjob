FROM alpine:3.12.0

RUN apk add aws-cli --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN apk add postgresql-client

WORKDIR /app

COPY pgdump-s3.sh pgdump-s3.sh
RUN chmod +x pgdump-s3.sh

ENTRYPOINT [ "/app/pgdump-s3.sh" ]