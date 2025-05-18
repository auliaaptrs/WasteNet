FROM golang:latest

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY PenarikanService/ ./PenarikanService

WORKDIR /app/PenarikanService

RUN go build -o main .

EXPOSE 8080

CMD ["./main"]