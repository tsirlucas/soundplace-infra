variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = "map"

  default = {
    us-east-1 = "ami-a04529b6"
  }
}

variable "POSTGRES_USER" {}

variable "POSTGRES_PASSWORD" {}
