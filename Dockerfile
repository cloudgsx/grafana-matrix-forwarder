FROM golang:tip-alpine3.22 AS builder
WORKDIR /src
COPY . .
WORKDIR /src/grafana-matrix-forwarder

# Static build -> no glibc/musl dependency
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -trimpath -ldflags="-s -w" -o grafana-matrix-forwarder .

FROM alpine:3.22
WORKDIR /app
# Trust roots if you do HTTPS (Matrix homeserver etc.)
RUN apk add --no-cache ca-certificates
COPY --from=builder /src/grafana-matrix-forwarder/grafana-matrix-forwarder .
EXPOSE 6000
ENTRYPOINT ["/app/grafana-matrix-forwarder"]

