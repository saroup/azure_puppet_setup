provider "azurerm" {
  features {}
  #subscription_id = var.subscription_id
  #client_id = var.client_id
  #client_certificate_path = var.client_certificate_path
  #client_certificate_password = ""
  #tenant_id = var.tenant_id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}