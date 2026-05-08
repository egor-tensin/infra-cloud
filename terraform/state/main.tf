module "state" {
  source = "github.com/egor-tensin/infra-terraform//aws/state?ref=v1.4.0-test"

  bucket_name         = "tensin-terraform-state"
}
