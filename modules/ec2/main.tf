# Generate SSH key pair
resource "tls_private_key" "instance_key" {
  count = var.create_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

# save the private key in local
resource "local_file" "private_key" {
  count = var.create_key ? 1 : 0
  content         = tls_private_key.instance_key[0].private_key_pem
  filename        = "${path.root}/${var.ec2_name}-key.pem"
  file_permission = "0400"

  lifecycle {
    prevent_destroy = false   # Prevents Terraform from deleting the file
    ignore_changes  = [content, filename]  # Ignores changes if the file is moved or deleted
  }
}

# create ec2 key to attach to ec2
resource "aws_key_pair" "instance_key" {
  count = var.create_key ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.instance_key[0].public_key_openssh
}

resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = var.subnet_id
  # vpc_security_group_ids = [module.sg.security_group_id]
  vpc_security_group_ids = var.sg_ids
  disable_api_termination = var.termination_protection

  root_block_device {
    volume_type = var.vol_type
    volume_size = var.vol_size

    tags = merge(
      {
        Name = "${var.ec2_name}-root-vol"
        Env = var.env
      },
      var.vol_tags
    )
  }

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
  instance = aws_instance.ec2.id

  tags = {
    Name = "${var.ec2_name}-ip"
    Env = var.env
  }
}

resource "null_resource" "ansible" {
  count = var.run_ansible ? 1 : 0
  
  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
      ansible-playbook \
      -i "${aws_instance.ec2.public_ip}," \
      --private-key "${local_file.private_key[0].filename}" \
      -u ubuntu \
      ansible/playbook.yml
    EOT
  }

  depends_on = [ aws_instance.ec2 ]
}