locals {
  default = {
    web_ingress = [
        {from_port = 80, to_port = 80, protocol = "tcp", cidr_block = var.public_cidr},
        {from_port = 443, to_port = 443, protocol = "tcp", cidr_block = var.public_cidr}
    ]

    ssh_ingress = [
        {from_port = 22, to_port = 22, protocol = "tcp", cidr_block = var.vpn_ip}
    ]

    egress = [
        {from_port = -1, to_port = -1, protocol = -1, cidr_block = var.public_cidr}
    ]

    mehedi_pubkey = "ssh-rsa ....."
    project-1-ec2-pubkey = "ssh-rsa ....."
    ubuntu24-ap-south-1-ami = "ami-0e35ddab05955cf57"
  }
}