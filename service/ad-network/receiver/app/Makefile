export GOOS ?=
export GOARCH ?=

include $(if $(CI),ci.mk,local.mk)

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
