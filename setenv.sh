export AWS_PROFILE=infra

IFS= read -r -s -p "Please enter you DigitalOcean token: " DIGITALOCEAN_TOKEN
export DIGITALOCEAN_TOKEN
echo

export YC_TOKEN="$( yc --profile infra iam create-token )"
