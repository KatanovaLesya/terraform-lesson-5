output "bucket_name" {
  description = "Назва створеного S3-бакета"
  value       = aws_s3_bucket.tf.bucket
}

output "table_name" {
  description = "Назва створеної таблиці DynamoDB"
  value       = aws_dynamodb_table.locks.name
}
