FROM golang:1.7.5-alpine

# install required libs
RUN apk --no-cache add git bash curl

# install glide package manager
RUN curl -Ls https://github.com/Masterminds/glide/releases/download/v0.12.1/glide-v0.12.1-linux-amd64.tar.gz | tar xz -C /tmp \
&& mv /tmp/linux-amd64/glide /usr/bin/

# cross compile tool for go
RUN go get -v github.com/mitchellh/gox

# code coverage tool
RUN go get -v golang.org/x/tools/cmd/cover

# convert go test results into junit.xml format
RUN go get -v github.com/jstemmer/go-junit-report

# create, edit and upload artifacts to Github releases
RUN go get github.com/aktau/github-release

COPY script ./script
