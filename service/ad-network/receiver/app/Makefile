export GOOS ?=
export GOARCH ?=

include $(if $(CI),ci.mk,local.mk)

.PHONY: clean
clean:
	-rm -rf artifact.tgz dist/bin/ad-network-receiver

.PHONY: lint
lint:
	go vet ./...

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: build
build: dist/bin/ad-network-receiver
dist/bin/ad-network-receiver: FORCE
	go build $(GO_BUILD_OPTIONS) -o $@
FORCE:

artifact.tgz: dist/bin/ad-network-receiver
	tar -czf $@ -C dist .
