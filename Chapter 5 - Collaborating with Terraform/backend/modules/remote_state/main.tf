resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.prefix}-remote-state-${var.environment}"
  lifecycle {
    prevent_destroy = false
}
  tags = {
    Name = "${var.prefix}-remote-state-${var.environment}"
    Environment = var.environment
  } 
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.remote_state.id
  acl    = "authenticated-read"
}