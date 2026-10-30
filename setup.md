On _my_ machines, this should _theoritically_ be fully automated by
[infra-metal].

[infra-metal]: https://github.com/egor-tensin/infra-metal

### AWS

* **CLI**:

      aws --profile infra configure

    * The default region should be "eu-central-1".

* **Terraform**: if you configured the CLI, you can do

      export AWS_PROFILE=infra

    * Otherwise, you'll need to set `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`.

### DigitalOcean

* **CLI**:

      doctl auth init --context infra

* **Terraform**: unfortunately, you have to set `DIGITALOCEAN_TOKEN` - there is
no way to pick up the configured credentials from the CLI.

* **Ansible**: the playbooks use the DigitalOcean access token (for Let's
Encrypt DNS challenges).
Ansible will prompt for it unless `DIGITALOCEAN_TOKEN` is set.

### Yandex.Cloud

* **CLI**:

      yc config profile create infra
      yc --profile infra config set service-account-key PATH_TO_AUTHORIZED_KEY_FILE

    * Don't forget to remove the authorized key file!

* **Terraform**: if you configured the CLI, you can do

      export YC_TOKEN="$( yc --profile infra iam create-token )"

    * Otherwise, you'll need to set `YC_SERVICE_ACCOUNT_KEY_FILE` to the path
of the authorized key JSON file.
