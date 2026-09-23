# Vendor Terraform Azure Web Application

This repository contains a simple, vendor-style Terraform starting point for an Azure web application environment. All Azure resources are intentionally kept in a single `main.tf` so the configuration can be reviewed before it is refactored to enterprise standards.

## Resources

- Azure Resource Group
- Azure App Service Plan
- Azure Linux Web App
- Azure Storage Account
- Azure Key Vault
- Azure Application Insights

## Prerequisites

- Terraform 1.6 or later
- An Azure subscription
- Azure CLI authentication or AzureRM provider environment variables
- `ARM_SUBSCRIPTION_ID` set when using AzureRM provider 4.x

## Configure

Copy `terraform.tfvars.example` to `terraform.tfvars`, then change `unique_suffix` to a short value that is unique to your deployment. The suffix helps avoid collisions for globally unique Azure resource names.

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

## Validate

The following commands initialize the provider locally and validate the configuration. They do not deploy infrastructure.

```powershell
terraform init
terraform fmt -check
terraform validate
```

Review the configuration and your organization's standards before planning or applying it. No infrastructure has been deployed as part of this project setup.

