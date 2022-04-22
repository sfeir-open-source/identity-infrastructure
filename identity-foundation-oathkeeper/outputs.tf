output "oathkeeper_access_rules" {
  value     = local_file.oathkeeper_access_rules
  sensitive = true
}

output "oathkeeper_config" {
  value     = local_sensitive_file.oathkeeper_config
  sensitive = true
}
