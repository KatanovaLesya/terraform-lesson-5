# ===== outputs.tf =====
output "s3_backend_info" {
  value = module.s3_backend
}

output "vpc_info" {
  value = module.vpc
}

output "ecr_info" {
  value = module.ecr
}
