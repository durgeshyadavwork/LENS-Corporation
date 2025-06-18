variable "region" {
    default = "ap-south-1"
    description = "AWS Deploy Region"
  
}

variable "profile" {
    default = "kusum"
    description = "Profile use for deploy"
     
}

variable "jenkins_instance_ami" {
    default = "ami-0af9569868786b23a"
    type = string
  
}

variable "jenkins_instance_type" {
    default = "t3.medium"
    type = string
  
}

variable "jenkins_pem_key" {
    default = "kusum"
    type = string
  
}


