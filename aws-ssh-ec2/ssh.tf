resource "aws_key_pair" "cmtr-031bfa7b-keypair" {
  key_name   = "cmtr-031bfa7b-keypair"
  public_key = var.ssh_key

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-031bfa7b"
  }
}