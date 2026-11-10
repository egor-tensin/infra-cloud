infra-cloud
===========

Trying to make my cloud VM setups fully automated.

Setup
-----

See [setup.md](setup.md).

Goal
----

The goal is to be able to do this:

    . setenv.sh
    make destroy
    make apply
    make config

idempotetically.
If that doesn't work, it's a bug.

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

NB: after everything is set up, maintenance can be done via the GitHub
workflow.

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
