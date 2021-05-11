# Information about region
variable "region_info" {
  type = object({
    resource_group_name = string 
    name                = string
    location            = string
    cidr_start_index    = number
  })
}