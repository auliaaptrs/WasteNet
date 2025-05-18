FROM golang:latest

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY TransaksiService/ ./TransaksiService

WORKDIR /app/TransaksiService

RUN go build -o main .

EXPOSE 8080

CMD ["./main"]