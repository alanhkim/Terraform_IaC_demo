output "resource_group_name" {
  description = "Name of the Azure Resource Group."
  value       = azurerm_resource_group.main.name
}

output "web_app_name" {
  description = "Name of the Azure Linux Web App."
  value       = azurerm_linux_web_app.main.name
}

output "web_app_url" {
  description = "Default HTTPS URL of the Azure Linux Web App."
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account."
  value       = azurerm_storage_account.main.name
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "application_insights_connection_string" {
  description = "Connection string for Azure Application Insights."
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}