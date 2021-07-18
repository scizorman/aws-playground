FROM golang:1.16.6 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/api ./cmd/api

FROM scratch
COPY --from=builder /app/api /api
EXPOSE 1323
CMD [ "/api" ]
