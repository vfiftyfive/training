#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-a4f9f2c2
#
# Your subnet ID is:
#
#     subnet-9a479ed3
#
# Your security group ID is:
#
#     sg-00100979
#
# Your Identity is:
#
#     hdays-michel-heron
#

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "max_count" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-a4f9f2c2"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-9a479ed3"
  vpc_security_group_ids = ["sg-00100979"]
  count                  = "2"

  tags {
    "Identity" = "hdays-michel-heron"
    "myname"   = "myInstance"
    "role"     = "web"
    "name"     = "${count.index+1}/${var.max_count}"
  }
}

terraform {
  backend "atlas" {
    name = "nvermande/training"
  }
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}
