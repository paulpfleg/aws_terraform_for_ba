/* 
resource "aws_s3_bucket" "ffmpeg-node" {
  bucket = "ffmpeg-node"

 lifecycle {
   prevent_destroy = true
 }

    tags = {
    Name        = "ffmpeg-node"
  }

}
 */

/* resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.video_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} */

