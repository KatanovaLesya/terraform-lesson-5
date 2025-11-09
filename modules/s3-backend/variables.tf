variable "bucket_name" {
  description = "Назва S3-бакета для зберігання state файлу Terraform"
  type        = string
}

variable "table_name" {
  description = "Назва таблиці DynamoDB для блокування state"
  type        = string
  default     = "terraform-locks"
}
