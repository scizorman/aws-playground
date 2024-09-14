export GOOS ?=
export GOARCH ?=

include $(if $(CI),ci.mk,local.mk)

s3_artifact_bucket := ad-network-receiver-artifact

.PHONY: clean
clean:
	-rm -rf artifact.tgz dist/bin/ad-network-receiver

.PHONY: deps
deps:
	go mod download

.PHONY: lint
lint:
	go vet ./...

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: test
test:
	go test -v ./...

.PHONY: build
build: dist/bin/ad-network-receiver
dist/bin/ad-network-receiver: FORCE
	go build $(GO_BUILD_OPTIONS) -o $@
FORCE:

artifact.tgz: dist/bin/ad-network-receiver
	tar -czf $@ -C dist .

.PHONY:
upload: artifact.tgz
	$(aws) s3 cp $< s3://$(s3_artifact_bucket)/latest/$<
	$(aws) s3 cp $< s3://$(s3_artifact_bucket)/$$(git rev-parse --short HEAD)/$<
