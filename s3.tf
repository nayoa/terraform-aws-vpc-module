## S3 Object

resource "aws_s3_bucket_object" "ansible" {
  count  = length(var.ansible_files)
  bucket = var.ansible_s3_bucket
  key    = local.environment / element(var.ansible_files, count.index)
  source = path.module / element(var.ansible_files, count.index)
  etag   = md5(file(path.module / element(var.ansible_files, count.index)))

  tags = var.tags
}
