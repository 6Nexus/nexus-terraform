variable "ami_id" {
  type    = string
  default = "ami-0f9de6e2d2f067fca"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "key_name" {
  type    = string
  default = "id_rsa"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "size" {
  type    = number
  default = 30
}

variable "device_name" {
  type    = string
  default = "/dev/sdh"
}

variable "public_ec2_name" {
  type    = string
  default = "public-ec2"
}

variable "private_ec2_api_name" {
  type    = string
  default = "private-ec2-api"
}

variable "ebs_volume_name" {
  type    = string
  default = "data-volume"
}

variable "sg_group_name" {
  type    = string
  default = "default-security-group"
}