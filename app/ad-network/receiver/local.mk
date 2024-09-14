export GOFLAGS := -mod=mod

GO_BUILD_OPTIONS := -race

aws := aws-vault exec aws-playground -- aws
