
PACKAGE := github.com/ShinyTrinkets/overseer.go

REVISION_VAR := main.CommitHash
REVISION_VALUE ?= $(shell git rev-parse --short HEAD 2>/dev/null)
BUILT_VAR := main.BuildTime
BUILT_VALUE := $(shell date -u '+%Y-%m-%dT%I:%M:%S%z')

GOBUILD_LDFLAGS ?= \
	-X '$(REVISION_VAR)=$(REVISION_VALUE)' \
	-X '$(BUILT_VAR)=$(BUILT_VALUE)'

.PHONY: test clean deps build release

test:
	go test -v -race

deps:
	go get -x -ldflags "$(GOBUILD_LDFLAGS)"
	go get -t -x -ldflags "$(GOBUILD_LDFLAGS)"

build: deps
	(cd cmd/ && go build -o ../overseer -ldflags "$(GOBUILD_LDFLAGS)")

release: deps
	cd cmd/
	GOOS=darwin GOARCH=amd64 go build -o overseer-darwin -ldflags "-s -w $(GOBUILD_LDFLAGS)"
	GOOS=linux GOARCH=amd64 go build -o overseer-linux -ldflags "-s -w $(GOBUILD_LDFLAGS)"
	cd ..

clean:
	go clean -x -i ./...
