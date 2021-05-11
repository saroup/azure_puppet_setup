# These variables are required for authenticating to Azure using a 
# service principal and a client certificate
variable "region_info" {
  type = object({
    resource_group_name = string
    name                = string
    location            = string
  })
}

# Authentication details for the virtual machines
# Assumption is that an Azure SSH key has been 
# pre-created to use for VM authn.
variable "admin_auth" {
  type = object({
    user_name           = string
    public_key_name     = string
    resource_group_name = string
    admin_password      = string
  })
  sensitive = true
}

variable "linux_vm_info" {
  type = object({
    vm_count     = number
    os_publisher = string
    os_offer     = string
    os_sku       = string
    os_version   = string
    size         = string
  })
}

variable "certname" {
    description = "The certificate name that the puppet agent will use"
    type        = string
    default     = null
}