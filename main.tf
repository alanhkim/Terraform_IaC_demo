data "azurerm_client_config" "current" {}

locals {
  base_name       = "${var.application_name}${var.environment}"
  resource_prefix = "${var.application_name}-${var.environment}-${var.unique_suffix}"
  storage_name    = "${local.base_name}${var.unique_suffix}st"
  key_vault_name  = "${substr(local.base_name, 0, 16)}${var.unique_suffix}kv"

  common_tags = {
    Application = var.application_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Source      = "Third-party vendor"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_service_plan" "main" {
  name                = "${local.resource_prefix}-asp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = local.common_tags
}

resource "azurerm_application_insights" "main" {
  name                = "${local.resource_prefix}-appi"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  application_type    = "web"
  tags                = local.common_tags
}

resource "azurerm_linux_web_app" "main" {
  name                = "${local.resource_prefix}-web"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
  }
}

resource "azurerm_storage_account" "main" {
  name                            = local.storage_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.common_tags
}

resource "azurerm_key_vault" "main" {
  name                       = local.key_vault_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.common_tags
}