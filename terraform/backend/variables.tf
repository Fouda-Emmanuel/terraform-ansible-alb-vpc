variable "aws_region" {
  description = "Region name"
  default = "us-east-1"
}

variable "env_tag" {
  description = "Environment name"
  default = "Dev"
}

variable "s3_name" {
  description = "S3 bucket name"
  default = "emson-iam-s3-bucket"
}

variable "dynamodb_name" {
  description = "DynamoDB name"
  default = "my-state-lock-record"
}