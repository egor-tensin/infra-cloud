include prelude.mk

.PHONY: DO
DO:

tf_backend_config := $(abspath ./terraform/config.s3.tfbackend)

init/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform init: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform init '-backend-config=$(call escape,$(tf_backend_config))'

.PHONY: init
init: init/state
init: init/resources/vpn-ru/project init/resources/vpn-ru/server
init: init/resources/vpn/project init/resources/vpn/data init/resources/vpn/server
init: init/resources/web/project init/resources/web/data init/resources/web/server

plan/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform plan: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform plan -detailed-exitcode

.PHONY: plan
plan: plan/state
plan: plan/resources/vpn-ru/project plan/resources/vpn-ru/server
plan: plan/resources/vpn/project plan/resources/vpn/data plan/resources/vpn/server
plan: plan/resources/web/project plan/resources/web/data plan/resources/web/server
