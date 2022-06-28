
resource "aws_s3_bucket" "genomics_b" {
  bucket = var.s3_bucket
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.genomics_b.id
  key    = "pexels-lood-goosen-1235706.jpg"
  source = "pexels-lood-goosen-1235706.jpg"
  etag = filemd5("pexels-lood-goosen-1235706.jpg")

}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.genomics_b.id

  restrict_public_buckets = true
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default_sse" {
  bucket = aws_s3_bucket.genomics_b.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}