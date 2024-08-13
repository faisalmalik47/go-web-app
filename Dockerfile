# First stage: Build the Go binary
FROM golang:1.22.5 AS base
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
# RUN go build -o main .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .


#Second stage: main image

FROM gcr.io/distroless/base
# FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD ["./main"]
