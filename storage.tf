resource "aws_s3_bucket" "app_bucket" {
bucket = "jprice-cloudops-app-bucket-2026-demo"

tags = {
Name = "app-bucket"
Environment = "lab"
}
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
bucket = aws_s3_bucket.app_bucket.id

versioning_configuration {
status = "Enabled"
}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_encryption" {
bucket = aws_s3_bucket.app_bucket.id

rule {
apply_server_side_encryption_by_default {
sse_algorithm = "AES256"
}
}
}

resource "aws_s3_bucket_public_access_block" "app_bucket_block" {
bucket = aws_s3_bucket.app_bucket.id

block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}

resource "aws_dynamodb_table" "app_table" {
name = "cloudops-app-table"
billing_mode = "PAY_PER_REQUEST"
hash_key = "id"

attribute {
name = "id"
type = "S"
}

tags = {
Name = "cloudops-app-table"
Environment = "lab"
}
}

