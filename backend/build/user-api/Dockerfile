FROM golang:1.16.5 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o /app/user-api ./cmd/user-api

FROM scratch
COPY --from=builder /app/user-api /user-api
EXPOSE 50051
CMD [ "/user-api" ]
