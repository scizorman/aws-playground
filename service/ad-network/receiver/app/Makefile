export GOOS ?=
export GOARCH ?=

ifeq ($(CI),true)
include ci.mk
else
include local.mk
endif

.PHONY: clean
clean:
	-rm -rf bin

.PHONY: lint
lint:
	go vet ./...

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: build
build: bin/ad-network-receiver
bin/ad-network-receiver: FORCE
	go build $(GO_BUILD_OPTIONS) -o $@
FORCE:
