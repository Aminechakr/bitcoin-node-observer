FROM golang:1.24-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod tidy

COPY . .

RUN go build -o bitcoin-exporter cmd/main.go

EXPOSE 9100
CMD ["./bitcoin-exporter"]
