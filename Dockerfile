# Stage 1 - Build
FROM golang:alpine AS builder

ARG APP=ti-pbg-colaborativo-ms-cenario
ARG FULL_PATH=bitbucket.org/pbgrupo/${APP}

# Install git
RUN apk update && apk add --no-cache git

# Install dep
RUN go get -u github.com/golang/dep/cmd/dep

# Copy the code from the host and compile it
WORKDIR $GOPATH/src/${FULL_PATH}
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure --vendor-only -v
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app .

EXPOSE 8080

# Stage 2 - Run
FROM scratch
COPY --from=builder /app ./
ENTRYPOINT ["./app"]