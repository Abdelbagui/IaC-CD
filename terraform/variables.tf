variable "resource_group_name" {
  default = "HASMA_abdel_RG"
}

variable "location" {
  default = "eastus"
}

variable "subscription_id" {
  description = "The subscription ID for Azure"
  type        = string
}
