FROM golang:1.16.6 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/aws-playground-api ./cmd/aws-playground

FROM scratch
COPY --from=builder /app/aws-playground-api /aws-playground-api
EXPOSE $SERVER_PORT
CMD [ "/aws-playground-api" ]
