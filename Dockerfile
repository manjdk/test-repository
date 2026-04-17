# STAGE 1: Build the binary
FROM golang:1.21-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# THIS IS THE MISSING LINK:
# It compiles your code into a binary named "test-repository"
RUN go build -o /test-repository

# STAGE 2: Run the binary
FROM alpine:latest
WORKDIR /

# Copy the binary from the builder stage to the final image
COPY --from=builder /test-repository /test-repository

# Set the binary as the entrypoint
ENTRYPOINT ["./test-repository"]