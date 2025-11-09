# ===== backend.tf =====
terraform {
  backend "s3" {
    bucket         = "lesya-terraform-backend-2025"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
