# Global variables
variable "location" {
  type    = string
  default = "israelcentral"
}

variable "resource_group_name" {
  type    = string
  default = "rg-scalable-web-exam"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}