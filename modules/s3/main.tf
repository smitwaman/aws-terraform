# modules/s3_backend/main.tf

variable "bucket_name" {

bucket_name = "17022024"

}
variable "key" {
  default = "terraform.tfstate"
}
variable "region" {
region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = var.key
    region         = var.region
  }
}
