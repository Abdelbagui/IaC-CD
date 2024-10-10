variable "resource_group_name" {
  default = "HASMA_abdel_RG"
}

variable "location" {
  default = "eastus"
}

variable "appId" {
  type        = string
  description = "The Azure Active Directory Application ID"
  default     = "$AZURE_CLIENT_ID"
}

variable "password" {
  type        = string
  description = "The Azure Active Directory Application Secret"
  default     = "$AZURE_CLIENT_SECRET"
}

variable "tenant_id" {
  type        = string
  description = "The name of the contenant in the Azure Storage account"
  default     = "$AZURE_TENANT_ID"
}
variable "subscription_id" {
  type        = string
  description = "The Azure Active Directory Tenant ID"
  default     = "$AZURE_SUBSCRIPTION_ID"
}