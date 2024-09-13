export GOFLAGS := -mod=readonly

GO_BUILD_OPTIONS := -ldflags "-extldflags '-static' -s -w"
