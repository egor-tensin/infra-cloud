if [ -z "${ANSIBLE_VAULT_PASSWORD+x}" ]; then
    IFS= read -r -s -p "Please enter you Ansible Vault password: " ANSIBLE_VAULT_PASSWORD
    export ANSIBLE_VAULT_PASSWORD
    echo
else
    echo "Not prompting for Ansible Vault password again."
fi

export AWS_PROFILE=infra

if [ -z "${DIGITALOCEAN_TOKEN+x}" ]; then
    IFS= read -r -s -p "Please enter you DigitalOcean token: " DIGITALOCEAN_TOKEN
    export DIGITALOCEAN_TOKEN
    echo
else
    echo "Not prompting for DigitalOcean token again."
fi

# I don't consider these to be secret:
export YC_CLOUD_ID=b1gj2k9e657bo1fb29nv
export YC_FOLDER_ID=b1gv5jkqodfl3b96urfl

export YC_TOKEN="$( yc --profile infra iam create-token )"
