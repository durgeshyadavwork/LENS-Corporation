variable "region" {
    default = "ap-south-1"
    type = string
  
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "test"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "test-14"
}


variable "ec2_instance_ami" {
    default = "ami-0af9569868786b23a"
    type = string
  
}

variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
  
}

variable "ec2_instance_key" {
    default = "kusum"
    type = string
  
}