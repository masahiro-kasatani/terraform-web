# Makefile

SHELL = /bin/sh

.DEFAULT_GOAL := help

.PHONY: docs fmt lint validate tfsec plan apply destroy pipeline-build pipeline-deploy help

docs: ## readme.md 作成
	@./scripts/docs.sh .

fmt: ## Terraform fmt 実行
	@terraform fmt -recursive

lint: ## Terraform fmt check 実行
	@terraform fmt -recursive -check

validate: ## Terraform validate 実行
	@./scripts/validate.sh .

tfsec: ## tfsec 実行
	@[ -n "$(ENV)" ] || { echo "No ENV specified. Usage: make tfsec ENV=dev"; exit 1; }
	@./scripts/tfsec.sh ./envs/${ENV}

plan: ## Terraform plan 実行
	@[ -n "$(ENV)" ] || { echo "No ENV specified. Usage: make plan ENV=dev"; exit 1; }
	@./scripts/plan.sh ./envs/${ENV}

apply: ## Terraform apply 実行
	@[ -n "$(ENV)" ] || { echo "No ENV specified. Usage: make apply ENV=dev"; exit 1; }
	@./scripts/apply.sh ./envs/${ENV}

destroy: ## Terraform destroy 実行
	@[ -n "$(ENV)" ] || { echo "No ENV specified. Usage: make destroy ENV=dev"; exit 1; }
	@./scripts/destroy.sh ./envs/${ENV}

pipeline-build: ## パイプラインのビルド
	@make lint
	@make validate

help: ## ヘルプの表示
	@echo "Usage:\n    make \033[36m<command>\033[0m\n\nCommands:" >&2
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "%4s\033[36m%-10s\033[0m\n%8s%s\n", "", $$1, "", $$2}' >&2
