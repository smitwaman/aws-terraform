resource "aws_s3_bucket" "ed_media" {
    bucket = "ed-media-data-02"
    tags = {
    Application = "edshopper"
    Product = "www.edueki.com"
    }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.ed_media.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "cf_s3_bucket" {
  bucket                = aws_s3_bucket.ed_media.id
  acl                   = "public-read"
}

resource "aws_s3_bucket_policy" "public_policy" {
    bucket = aws_s3_bucket.ed_media.id
    policy = <<EOF
{
    "Id": "SourceIP",
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "SourceIP",
        "Action": "s3:*",
        "Effect": "Deny",
        "Resource": [
          "arn:aws:s3:::ed-media-data-02",
          "arn:aws:s3:::ed-media-data-02/*"
        ],
        "Condition": {
          "NotIpAddress": {
            "aws:SourceIp": [
              "49.205.35.242/32"
            ]
          }
        },
        "Principal": "*"
      }
    ]
  }
EOF
}