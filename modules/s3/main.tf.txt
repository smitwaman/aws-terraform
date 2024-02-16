# modules/s3_backend/main.tf

variable "bucket_name" {}
variable "key" {
  default = "terraform.tfstate"
}
variable "region" {}

terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = var.key
    region         = var.region
  }
}
