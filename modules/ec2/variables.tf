variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name used to ssh into ec2"
}

variable "availability_zones" {
  description = "Availability zones for Auto Scaling group"
  type        = list(string)
}

variable "tags" {
  description = "Resource tags"
}

variable "env" {
  description = "Env- Dev/Preprod/Prod"
}

