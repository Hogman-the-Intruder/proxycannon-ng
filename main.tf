module "proxycannon" {
  source = "./tfdocs/providers/aws"

  sshName = var.sshName
  key-file = var.key-file
  public_key = var.public_key
}