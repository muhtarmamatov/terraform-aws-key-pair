locals {
  name   = "ssh-key-${replace(basename(path.cwd), "_", "-")}"
  region = "us-east-1"
  public_key = "E:/keys/id_rsa_pub.txt"
  tags = {
    ssh-key-name = local.name
    developer    = "=== Muktarbek Mamatov ===="
    description  = "create aws key pair terraform"
  }
}

################################################################################
# Key Pair Module
################################################################################

module "key_pair" {
  source = "../modules"

  key_name           = local.name
  create_private_key = true

  create_local_file = true

  tags = local.tags
}

module "key_pair_external" {
  source = "../modules"

  key_name   = "${local.name}-external"
 # public_key = trimspace(tls_private_key.this.public_key_openssh)
  public_key = fileexists(local.public_key) ? file(local.public_key) : trimspace(tls_private_key.this.public_key_openssh)
  tags = local.tags
}

module "key_pair_disabled" {
  source = "../modules"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

resource "tls_private_key" "this" {
  algorithm = "RSA"
}