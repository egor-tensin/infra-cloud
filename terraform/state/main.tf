module "state" {
  source = "github.com/egor-tensin/infra-terraform//aws/state?ref=v0.0.3"

  bucket_name         = "tensin-terraform-state"
  dynamodb_table_name = "tensin-terraform-locks"
}
