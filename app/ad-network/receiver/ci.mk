export GOOS := linux
export GOARCH := arm64
export GOFLAGS := -mod=readonly

GO_BUILD_OPTIONS := -ldflags "-extldflags '-static' -s -w"

aws := aws
