variable "bucket_name" {
  description = "Name of the S3 bucket"
}


resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.bucket_name
  acl    = "private" # Set ACL as needed
}

resource "aws_s3_bucket_object" "tfstate_file" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  key    = "./*.tfstate"

}
