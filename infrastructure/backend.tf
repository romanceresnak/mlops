terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "terraform_st_resource_group" {
  type = string
}

variable "terraform_st_location" {
  type = string
}

variable "terraform_st_storage_account" {
  type = string
}

variable "terraform_st_container_name" {
  type = string
}

# Create Resource Group
resource "azurerm_resource_group" "tfstate" {
  name     = var.terraform_st_resource_group
  location = var.terraform_st_location
}

# Create Storage Account
resource "azurerm_storage_account" "tfstate" {
  name                     = var.terraform_st_storage_account
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    environment = "terraform-state"
  }
}

# Create Storage Container
resource "azurerm_storage_container" "tfstate" {
  name                  = var.terraform_st_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}

output "resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}