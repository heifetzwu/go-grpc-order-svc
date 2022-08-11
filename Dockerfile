# FROM golang:1.15.12-alpine3.13 as builder
FROM golang:1.18.5-alpine3.16 as builder
ARG BINARY=go-grpc-order-svc
RUN apk update && apk upgrade && apk --update add git make

WORKDIR /app

COPY . .

RUN make engine


FROM alpine:latest
ARG BINARY=go-grpc-product-svc
RUN apk update --no-cache && apk upgrade && apk --update --no-cache add tzdata && mkdir /app
WORKDIR /app
EXPOSE 50003

COPY --from=builder /app/go-grpc-order-svc /app 
COPY --from=builder /app/pkg/config /app/pkg/config
RUN echo ${BINARY}
CMD /app/go-grpc-order-svc
# CMD echo "run" && sleep 60