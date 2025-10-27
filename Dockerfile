FROM alpine:latest

COPY config config
COPY swagger swagger
COPY migrations migrations
COPY vector.yaml vector.yaml

COPY main main

CMD ["/bin/sh", "./main"]
