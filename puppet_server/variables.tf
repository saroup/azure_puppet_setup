variable "ssh_key" {
    description = "SSH Key to use for linux instances."
    type        = string
    default     = null
}

variable "admin_user" {
    description = "The admin user used to connect to vm"
    type        = string
    default     = "teamgemini"
}


variable "admin_password" {
    description = "The admin user used to connect to vm"
    type        = string
    default     = "null"
}

# Information about region
variable "region_info" {
  type = object({
    resource_group_name = string 
    name                = string
    location            = string
    cidr_start_index    = number
  })
}

variable "certname" {
    description = "The certificate that the puppet server will auto sign"
    type        = string
    default     = null
}

variable "gitlab_control_repo" {
  description   = "The repo to which r10k will connect to download puppet code"
  type          = string
  default       = null
}

variable "registration_token" {
  description = "The token used to setup the gitlab-runner with the wanted repo"
  type        = string
  default     = null
  sensitive   = true
}
