provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_s3_bucket_proj" {
  bucket = var.s3_name

  tags = {
    Name        = var.s3_name
    Environment = var.env_tag 
  }

 lifecycle {
   prevent_destroy = false
 }
}

resource "aws_s3_bucket_versioning" "my_s3_bucket_proj_versioning" {
  bucket = aws_s3_bucket.my_s3_bucket_proj.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "my_dynamodb_proj" {
  name           = var.dynamodb_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  tags = {
  Name        = var.dynamodb_name
  Environment = var.env_tag
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
