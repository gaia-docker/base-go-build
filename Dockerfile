FROM golang:1.8-alpine

# install git, bash & curl
RUN apk --no-cache add git bash curl

# install glide package manager
RUN curl -Ls https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz | tar xz -C /tmp \
&& mv /tmp/linux-amd64/glide /usr/bin/

# cross compile tool for go
RUN go get -v github.com/mitchellh/gox

# code coverage tool
RUN go get -v golang.org/x/tools/cmd/cover

# convert go test results into junit.xml format
RUN go get -v github.com/jstemmer/go-junit-report

COPY script ./script
