terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    # We include 'random' just in case we need to generate unique IDs later
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # This allows Terraform to delete the RG even if you manually added extra stuff inside it.
      # Very helpful for 'Demo' environments so 'terraform destroy' doesn't get stuck.
      prevent_deletion_if_contains_resources = false
    }   
  }
  # Note: We rely on 'az login' for authentication, so no secrets are hardcoded here.
}