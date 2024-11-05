Setting up
==========

AWS
---

### CLI

    aws --profile infra configure

The default region should be "eu-central-1".

### Terraform

* If you configured the CLI, you can do

      export AWS_PROFILE=infra

* Otherwise, you need to set `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`.

DigitalOcean
------------

### CLI

    doctl auth init --context infra

### Terraform

* Unfortunately, you have to set `DIGITALOCEAN_TOKEN` - there is no way to pick
up the configured credentials from the CLI.

### Ansible

* The playbooks use the DigitalOcean access token (for Let's Encrypt DNS
challenges).
Ansible will prompt for it unless `DIGITALOCEAN_TOKEN` is set.

Yandex.Cloud
------------

### CLI

    yc config profile create infra
    yc --profile infra config set service-account-key PATH_TO_AUTHORIZED_KEY_FILE

Don't forget to remove the authorized key file!

### Terraform

* If you configured the CLI, you can do

      export YC_TOKEN="$( yc --profile infra iam create-token )"

* Otherwise, you need to set `YC_SERVICE_ACCOUNT_KEY_FILE` to the path of the
authorized key JSON file.

Terraform
---------

* If you configured the CLIs, you can do

      . setenv.sh

  This will set the required environment variables.

* To initialize the modules, run:

      make init

* Upgrade providers:

      make upgrade

Usage
=====

Terraform
---------

* Check if the infrastructure matches configuration:

      make plan

* Apply the configuration to the infrastructure:

      make apply

Ansible
-------

* Run the playbook for all hosts:

      make config

* Run the playbook for a subset of hosts:

      make config LIMIT=PATTERN

* Reboot a host:

      make reboot LIMIT=HOST
