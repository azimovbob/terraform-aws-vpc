##############################
##      VPC Variables       ##
##############################
variable "cidr_block" {
  type        = string
  description = "VPC CIDR"
}

variable "vpc_common_tags" {
  type = map(string)
  default = {
    name = "main"
  }
  description = "VPC tags"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "enable_dns_support" {
  type    = bool
  default = false
}

##############################
##    Subnet Variables      ##
##############################
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public CIDR"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "private subnet tags"
  default     = {}
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private subnet cidr blocks"
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Private Subnet tags"
  default     = {}
}

variable "azs" {
  type        = list(string)
  description = "value"
}

#################################
##  Internet Gateway Variables ##
#################################

variable "igw_tags" {
  type        = map(string)
  default     = {}
  description = "Internet gateway tags"
}

