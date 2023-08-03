module "state" {
  source = "../modules/s3_state"

  bucket_name         = "tensin-terraform-state"
  dynamodb_table_name = "tensin-terraform-locks"
}
