
variable "vpc_cidr" {
  default = "10.10.0.0/16"

}

variable "subnet_cidr" {
  default = "10.10.10.0/24"

}

variable "ami-id" {
  default = "ami-0cff7528ff583bf9a"

}

variable "instance_type" {
  default = "t2.micro"

}

variable "username" {
  type    = list(any)
  default = ["UserA", "UserB"]

}

variable "ingress_cidr" {
  default = ["85.255.236.37/32"]

}

/*variable "ingress_ports" {
  type    = list(any)
  default = ["443", "80", "22", "5000"]
}*/

variable "key_name" {
    default = "id_rsa"
}

variable "s3_bucket" {
  default = "genom-06-22-test-bucket"

}
