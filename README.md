[![CircleCI](https://circleci.com/gh/gaia-docker/base-go-build.svg?style=shield)](https://circleci.com/gh/gaia-docker/base-go-build)
[![Docker](https://img.shields.io/docker/pulls/gaiadocker/base-go-build.svg)](https://hub.docker.com/r/gaiadocker/base-go-build/)
[![Docker Image Layers](https://imagelayers.io/badge/gaiadocker/base-go-build:latest.svg)](https://imagelayers.io/?images=gaiadocker/base-go-build:latest)

# base-go-build
Building and testing a go project requires to setup a machine with go and maybe tools like: cross compile, test coverage, glide, etc.
Building and running test coverage requires scripts. *base-go-build* Docker image contains all, so all you need to do in order to build or test your go project in running a docker container as follow:
##### Build:
```bash
docker run --rm -v "$PWD":$PROJECT_PATH -w $PROJECT_PATH gaiadocker/base-go-build /go/script/go_build.sh $PROJECT_NAME
```
##### Test & Coverage:
```bash
docker run --rm -v "$PWD":$PROJECT_PATH -w $PROJECT_PATH $BUILDER_IMAGE_NAME /go/script/coverage.sh
```
Creates a _.cover_ folder with test and coverage results.
### CircleCI
If you are using _CircleCI_ for building and testing your go project, see follow _circle.yml_ which using _base-go-build_ docker image:
```yml
machine:
  environment:
    PROJECT_NAME: tugbot
    PROJECT_PATH: /go/src/github.com/gaia-docker/$PROJECT_NAME
    BUILDER_IMAGE_NAME: gaiadocker/base-go-build
dependencies:
  override:
    # run go build in a docker container
    - docker run --rm -v "$PWD":$PROJECT_PATH -w $PROJECT_PATH $BUILDER_IMAGE_NAME /go/script/go_build.sh $PROJECT_NAME
test:
  override:
    # run tugbot tests and generate junit.xml reports
    - docker run --rm -v "$PWD":$PROJECT_PATH -w $PROJECT_PATH $BUILDER_IMAGE_NAME /go/script/coverage.sh
  post:
    # copy test results
    - cp .cover/*_tests.xml $CIRCLE_TEST_REPORTS
general:
  artifacts:
    - .dist
    - .cover
```
