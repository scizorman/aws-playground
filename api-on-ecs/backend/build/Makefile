SCOPE :=
TAG   := $(shell git rev-parse --short --verify HEAD)

repository := 217082601537.dkr.ecr.ap-northeast-1.amazonaws.com/aws-playground/$(SCOPE)

.PHONY: build
build:
	@docker build -t $(repository):$(TAG) -f $(SCOPE)/Dockerfile ..

.PHONY: login
login:
	@aws ecr get-login-password --region ap-northeast-1 \
		| docker login --username AWS --password-stdin $(repository)

.PHONY: push
push: build login
	@docker push $(repository):$(TAG)
