FROM golang:1.16.5 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o /app/api-gateway ./cmd/api-gateway

FROM scratch
COPY --from=builder /app/api-gateway /api-gateway
CMD [ "/api-gateway" ]
