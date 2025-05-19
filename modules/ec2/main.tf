# # Generate SSH key pair
# resource "tls_private_key" "instance_key" {
#   count = var.create_key ? 1 : 0
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # save the private key in local
# resource "local_file" "private_key" {
#   count = var.create_key ? 1 : 0
#   content         = tls_private_key.instance_key[0].private_key_pem
#   filename        = "${path.root}/${var.ec2_name}-key.pem"
#   file_permission = "0400"

#   lifecycle {
#     prevent_destroy = false   # Prevents Terraform from deleting the file
#     ignore_changes  = [content, filename]  # Ignores changes if the file is moved or deleted
#   }
# }

# # create ec2 key to attach to ec2
# resource "aws_key_pair" "instance_key" {
#   count = var.create_key ? 1 : 0
#   key_name   = var.key_name
#   public_key = tls_private_key.instance_key[0].public_key_openssh
# }

resource "aws_key_pair" "ec2_key" {
  public_key = var.default_user_pubkey
}

# for custim AMI with volsize
data "aws_ami" "ami" {
  count = var.vol_size == null ? 1 : 0
  owners = ["self"]
  filter {
    name   = "image-id"
    values = [var.ami]
  }
}

resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key.key_name

  subnet_id = var.subnet_id
  # vpc_security_group_ids = [module.sg.security_group_id]
  vpc_security_group_ids = var.sg_ids
  disable_api_termination = var.termination_protection

  root_block_device {
    volume_type = var.vol_type
    volume_size = var.vol_size != null ? var.vol_size : tolist(data.aws_ami.ami[0].block_device_mappings)[0].ebs.volume_size

    tags = merge(
      {
        Name = "${var.ec2_name}-root-vol"
        Env = var.env
      },
      var.vol_tags
    )
  }

  # Add userdata through file
  user_data = templatefile("${path.module}/user_data.sh.tmpl", {
    ssh_users = var.ssh_users
  })

  # When used in combination with user_data or user_data_base64 will trigger a destroy and recreate of the EC2 instance when set to true
  # Recreates ec2 with it only if the userdata changed from previous userdata.
  user_data_replace_on_change = var.user_data_replace_on_change

  tags = merge(
    {
      Name = var.ec2_name
      Env = var.env
    },
    var.tags # This allows the user to pass additional tags
  )
}

resource "aws_eip" "eip" {
  count = var.eip ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.ec2_name}-ip"
    Env = var.env
  }
}

resource "aws_eip_association" "eip" {
  count = var.eip ? 1:0
  instance_id = aws_instance.ec2.id
  allocation_id = aws_eip.eip[0].id 
}

# resource "null_resource" "ansible" {
#   count = var.run_ansible ? 1 : 0
  
#   provisioner "local-exec" {
#     command = <<EOT
#       ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
#       ansible-playbook \
#       -i "${aws_instance.ec2.public_ip}," \
#       --private-key "${local_file.private_key[0].filename}" \
#       -u ubuntu \
#       ansible/playbook.yml
#     EOT
#   }

#   depends_on = [ aws_instance.ec2 ]
# }