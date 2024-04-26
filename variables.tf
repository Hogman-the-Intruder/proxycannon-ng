# key-file should be the full location of the private key used for the VPS of choice
variable "key-file" {}

variable "public_key" {
  description = "The PUBLIC key to use for SSH auth to the instances."
}

# name should be set to the name of the public key onfile with your provider
variable "sshName" {}