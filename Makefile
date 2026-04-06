include prelude.mk

.PHONY: all
all: maintenance

ifndef DIGITALOCEAN_TOKEN
$(error Please execute `source setenv.sh` first)
endif

.PHONY: DO
DO:

tf_backend_config := $(abspath ./terraform/config.s3.tfbackend)

tf_init_args :=

# I have no idea why terraform wouldn't just delete old provider versions from
# .terraform/providers/. After a few iterations, especially for AWS, that
# folder ends up taking many GBs, so I'm just going to remove it manually. This
# sucks, but bloating your hard drive with useless crap is worse. References:
#
#     * https://github.com/hashicorp/terraform/issues/28286
#     * https://discuss.hashicorp.com/t/purging-old-provider-plugin-bloat/44283
#
init/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform init: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		rm -rf -- ./.terraform/providers && \
		terraform init $(tf_init_args) '-backend-config=$(call escape,$(tf_backend_config))'

.PHONY: init
init: init/state
init: init/meta init/data
init: init/vpn-ru
init: init/vpn
init: init/web

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
plan: plan/vpn-ru
plan: plan/vpn
plan: plan/web

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
apply: apply/vpn-ru
apply: apply/vpn
apply: apply/web

destroy/%: DO
	@echo
	@echo -----------------------------------------------------------------
	@echo 'terraform destroy: $*'
	@echo -----------------------------------------------------------------
	@cd -- 'terraform/$*/' && \
		terraform destroy

.PHONY: destroy
destroy: destroy/web
destroy: destroy/vpn
destroy: destroy/vpn-ru

.PHONY: deps
deps:
	@echo
	@echo -----------------------------------------------------------------
	@echo Installing Ansible dependencies
	@echo -----------------------------------------------------------------
	@ansible-galaxy install -r ansible/requirements.yml

LIMIT ?= all
$(eval $(call noexpand,LIMIT))

.PHONY: configure
configure: deps
	@echo
	@echo -----------------------------------------------------------------
	@echo ansible-playbook
	@echo -----------------------------------------------------------------
	@cd -- ansible/ && \
		ansible-playbook --limit '$(call escape,$(LIMIT))' playbook.yml

.PHONY: config
config: configure

.PHONY: check-ports
check-ports:
	@echo
	@echo -----------------------------------------------------------------
	@echo Checking open ports
	@echo -----------------------------------------------------------------
	@sudo ./utils/check_ports.py

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
	@$(MAKE) check-ports

.PHONY: reboot
reboot:
	@echo
	@echo -----------------------------------------------------------------
	@echo Rebooting hosts
	@echo -----------------------------------------------------------------
	@cd -- ansible/ && \
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
