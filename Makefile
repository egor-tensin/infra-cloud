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

LIMIT ?= all
$(eval $(call noexpand,LIMIT))

.PHONY: configure
configure:
	@echo
	@echo -----------------------------------------------------------------
	@echo ansible-playbook
	@echo -----------------------------------------------------------------
	@cd -- ansible && \
		ansible-playbook --limit '$(call escape,$(LIMIT))' playbook.yml

.PHONY: config
config: configure

.PHONY: reboot
reboot:
	@echo
	@echo -----------------------------------------------------------------
	@echo Rebooting hosts
	@echo -----------------------------------------------------------------
	@cd -- ansible && \
		ansible --become --limit '$(call escape,$(LIMIT))' -m reboot all

tf_show_id := terraform output -raw id

do_start := doctl --context infra compute droplet-action power-on --format Status,CompletedAt --wait
do_stop  := doctl --context infra compute droplet-action shutdown --format Status,CompletedAt --wait

yc_start := yc --profile infra compute instance start --id
yc_stop  := yc --profile infra compute instance stop  --id

digitalocean/%/start: DO
	@id="$$( cd -- '$(call escape,terraform/resources/$*/server)' && $(tf_show_id) )" && \
		$(do_start) "$$id"

digitalocean/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/resources/$*/server)' && $(tf_show_id) )" && \
		$(do_stop) "$$id"

yandex_cloud/%/start: DO
	@id="$$( cd -- '$(call escape,terraform/resources/$*/server)' && $(tf_show_id) )" && \
		$(yc_start) "$$id"

yandex_cloud/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/resources/$*/server)' && $(tf_show_id) )" && \
		$(yc_stop) "$$id"

vpn/%: digitalocean/vpn/% ;
web/%: digitalocean/web/% ;

vpn-ru/%: yandex_cloud/vpn-ru/% ;
