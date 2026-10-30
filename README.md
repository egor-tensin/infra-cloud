infra-cloud
===========

Trying to make my cloud VM setups fully automated.

Setup
-----

See [setup.md](setup.md).

Terraform
---------

* Once you configured the CLIs, you can do

      . setenv.sh

  This will set the required environment variables.

* To initialize the modules, run:

      make init

* Upgrade providers:

      make upgrade

Usage
-----

### Terraform

* Check if the infrastructure matches configuration:

      make plan

* Apply the configuration to the infrastructure:

      make apply

### Ansible

* Run the playbook for all hosts:

      make config

* Run the playbook for a subset of hosts:

      make config LIMIT=PATTERN

* Reboot a host:

      make reboot LIMIT=HOST
