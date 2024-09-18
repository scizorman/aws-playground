include $(if $(CI),ci.mk,local.mk)

.PHONY: clean
clean:
	find . -type d -name '.terraform' -exec rm -rf {} +

.PHONY: lint
lint:
	terraform fmt -check -diff -recursive

.PHONY: fmt
fmt:
	terraform fmt -recursive

%/.terraform: %/.terraform.lock.hcl
	$(terraform_command) -chdir=$* init
	@touch $@
.PRECIOUS: %/.terraform.lock.hcl
%/.terraform.lock.hcl:
	@touch $@

.PHONY: show
show: $(STACK)/.terraform
	$(terraform_command) -chdir=$(<D) show

.PHONY: validate
validate: $(STACK)/.terraform
	$(terraform_command) -chdir=$(<D) validate

.PHONY: plan
plan: validate
	$(terraform_command) -chdir=$(STACK) plan -detailed-exitcode

.PHONY: apply
apply: validate
	$(terraform_command) -chdir=$(STACK) apply

.PHONY: destroy
destroy: $(STACK)/.terraform
	$(terraform_command) -chdir=$(STACK) destroy -auto-approve=false
