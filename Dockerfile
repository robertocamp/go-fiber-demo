FROM golang:1.16-alpine as builder


WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
RUN go mod download
COPY . .

RUN go build -o ./fiber/demo .


# CMD ./fiber/demo


###########START NEW IMAGE###################

FROM golang:1.16-alpine as deploy
COPY --from=builder . .
CMD ./fiber/demo
