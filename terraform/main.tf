module "ec2" {
  source        = "./modules/ec2-instance"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = aws_key_pair.ssh_key.key_name
  subnet_id     = var.subnet_id
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}
