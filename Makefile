include prelude.mk

ifndef DIGITALOCEAN_TOKEN
$(error Please execute `source setenv.sh` first)
endif

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
init: init/meta init/data
init: init/vpn-ru init/vpn init/web

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
plan: plan/meta plan/data
plan: plan/vpn-ru plan/vpn plan/web

apply/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform apply: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform apply

.PHONY: apply
apply: apply/state
apply: apply/meta apply/data
apply: apply/vpn-ru apply/vpn apply/web

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

.PHONY: maintenance
maintenance:
	@$(MAKE) upgrade
	@echo
	@echo -----------------------------------------------------------------
	@echo Checking for file modifications
	@echo -----------------------------------------------------------------
	@git_status="$$( git status --porcelain=v1 )" && \
	file_statuses="$$( echo "$$git_status" | cut -c 1-2 | sort -u )" && \
	file_names="$$( echo "$$git_status" | cut -c 4- | grep -o '[^/]*$$' | sort -u )" && \
	if [ -z "$$git_status" ]; then \
		true ; \
	elif [ "$$file_statuses $$file_names" = ' M .terraform.lock.hcl' ]; then \
		git commit -am 'terraform: upgrade providers' && \
			git push -q ; \
	else \
		echo ; \
		echo '-----------------------------------------------------------------'; \
		echo 'Error: unrecognized modifications in the repository'; \
		echo '-----------------------------------------------------------------'; \
		exit 1; \
	fi
	@$(MAKE) plan
	@$(MAKE) configure

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
	@id="$$( cd -- '$(call escape,terraform/$*)' && $(tf_show_id) )" && \
		$(do_start) "$$id"

digitalocean/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/$*)' && $(tf_show_id) )" && \
		$(do_stop) "$$id"

yandex_cloud/%/start: DO
	@id="$$( cd -- '$(call escape,terraform/$*)' && $(tf_show_id) )" && \
		$(yc_start) "$$id"

yandex_cloud/%/stop: DO
	@id="$$( cd -- '$(call escape,terraform/$*)' && $(tf_show_id) )" && \
		$(yc_stop) "$$id"

vpn/%: digitalocean/vpn/% ;
web/%: digitalocean/web/% ;

vpn-ru/%: yandex_cloud/vpn-ru/% ;
