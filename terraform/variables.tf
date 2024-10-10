variable "resource_group_name" {
  default = "HASMA_abdel_RG"
}

variable "location" {
  default = "eastus"
}

variable "appId" {
  type        = string
  description = "The Azure Active Directory Application ID"
}

variable "password" {
  type        = string
  description = "The Azure Active Directory Application Secret"
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory Tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
}