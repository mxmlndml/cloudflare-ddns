FROM golang:1.22 AS compile

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
# COPY go.mod go.sum ./
# RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /usr/local/bin/app ./...

FROM scratch AS service

WORKDIR /
COPY --from=compile /usr/local/bin/app .

ENTRYPOINT ["/app"]
