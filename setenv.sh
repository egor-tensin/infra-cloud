export AWS_PROFILE=infra

if [ -z "${DIGITALOCEAN_TOKEN+x}" ]; then
    IFS= read -r -s -p "Please enter you DigitalOcean token: " DIGITALOCEAN_TOKEN
    export DIGITALOCEAN_TOKEN
    echo
else
    echo "Not prompting for DigitalOcean token again."
fi

export YC_TOKEN="$( yc --profile infra iam create-token )"
