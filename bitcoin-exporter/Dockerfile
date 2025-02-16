FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod tidy

COPY . .

RUN go build -o bitcoin-exporter cmd/main.go

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bitcoin-exporter /app/bitcoin-exporter

EXPOSE 9100

CMD ["./bitcoin-exporter"]
