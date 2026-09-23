variable "location" {
  description = "Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Short environment name used in resource names and tags."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9]{2,8}$", var.environment))
    error_message = "Environment must contain 2-8 lowercase letters or numbers."
  }
}

variable "application_name" {
  description = "Short application name used in resource names and tags."
  type        = string
  default     = "vendorapp"

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,11}$", var.application_name))
    error_message = "Application name must contain 3-12 lowercase letters or numbers and start with a letter."
  }
}

variable "unique_suffix" {
  description = "Short suffix used to reduce collisions for globally unique Azure resource names."
  type        = string
  default     = "001"

  validation {
    condition     = can(regex("^[a-z0-9]{3,6}$", var.unique_suffix))
    error_message = "Unique suffix must contain 3-6 lowercase letters or numbers."
  }
}