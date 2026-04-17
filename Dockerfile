FROM alpine:latest

COPY test-repository test-repository

CMD ["./test-repository"]