include prelude.mk

.PHONY: DO
DO:

tf_backend_config := $(abspath ./terraform/config.s3.tfbackend)

tf_init_args :=

init/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform init: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform init $(tf_init_args) '-backend-config=$(call escape,$(tf_backend_config))'

.PHONY: init
init: init/state
init: init/vpn-ru/project init/vpn-ru/server
init: init/vpn/project init/vpn/data init/vpn/server
init: init/web/project init/web/data init/web/server

.PHONY: upgrade
upgrade: tf_init_args := -upgrade
upgrade: init

plan/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform plan: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform plan -detailed-exitcode

.PHONY: plan
plan: plan/state
plan: plan/vpn-ru/project plan/vpn-ru/server
plan: plan/vpn/project plan/vpn/data plan/vpn/server
plan: plan/web/project plan/web/data plan/web/server

.PHONY: deps
deps:
	@echo
	@echo -----------------------------------------------------------------
	@echo Installing Ansible dependencies
	@echo -----------------------------------------------------------------
	@ansible-galaxy install -r ansible/requirements.yml

LIMIT ?= all
$(eval $(call noexpand,LIMIT))

ansible_dir := ansible/managed

.PHONY: configure
configure: deps
	@echo
	@echo -----------------------------------------------------------------
	@echo ansible-playbook
	@echo -----------------------------------------------------------------
	@cd -- '$(call escape,$(ansible_dir))' && \
		ansible-playbook --limit '$(call escape,$(LIMIT))' playbook.yml

.PHONY: config
config: configure

.PHONY: configure/bare_metal
configure/bare_metal: ansible_dir := ansible/bare_metal
configure/bare_metal: configure

.PHONY: config/bare_metal
config/bare_metal: configure/bare_metal

.PHONY: reboot
reboot:
	@echo
	@echo -----------------------------------------------------------------
	@echo Rebooting hosts
	@echo -----------------------------------------------------------------
	@cd -- ansible/managed/ && \
		ansible --become --limit '$(call escape,$(LIMIT))' -m reboot all

tf_show_id := terraform output -raw id

doctl := doctl --context infra
yc    := yc --profile infra

do_args  := --format Status,CompletedAt --wait
do_start := $(doctl) compute droplet-action power-on $(do_args)
do_stop  := $(doctl) compute droplet-action shutdown $(do_args)

yc_start := $(yc) compute instance start --id
yc_stop  := $(yc) compute instance stop  --id

digitalocean/%/start: DO
	@id="$$( cd -- '$(call escape,terraform/$*/server)' && $(tf_show_id) )" && \
		$(do_start) "$$id"

digitalocean/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/$*/server)' && $(tf_show_id) )" && \
		$(do_stop) "$$id"

yandex_cloud/%/start: DO
	@id="$$( cd -- '$(call escape,terraform/$*/server)' && $(tf_show_id) )" && \
		$(yc_start) "$$id"

yandex_cloud/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/$*/server)' && $(tf_show_id) )" && \
		$(yc_stop) "$$id"

vpn/%: digitalocean/vpn/% ;
web/%: digitalocean/web/% ;

vpn-ru/%: yandex_cloud/vpn-ru/% ;
