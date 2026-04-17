FROM alpine:latest

RUN go build -o /test-repository

COPY --from=builder /test-repository /test-repository

ENTRYPOINT ["./test-repository"]