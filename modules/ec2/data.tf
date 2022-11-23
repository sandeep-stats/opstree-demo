data "aws_ami" "opstree_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*-x86_64-gp2"]
  }
}
