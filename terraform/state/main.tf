module "state" {
  source = "github.com/egor-tensin/infra-terraform//aws/state?ref=v2.0.0"

  bucket_name = "tensin-terraform-state"
}
