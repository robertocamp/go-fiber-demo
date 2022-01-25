FROM golang:1.16-alpine as dev

WORKDIR /demo


FROM golang:1.16-alpine as build
WORKDIR /fiber
COPY ./demo/* /fiber/
RUN cd /fiber && go mod download


RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o demo .
###########START NEW IMAGE###################
FROM alpine:latest
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
# FROM golang:1.16-alpine as deploy
COPY --from=build /fiber/demo ./
# COPY --from=builder . .
CMD ["./demo"]
