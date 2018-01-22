
# user_data
# ============================================================================
data "template_file" "cloud-config" {
  template = "${file("${path.module}/etc/cloud-config.yaml")}"
  vars {
    user = "${var.user}"
    user_sshkey = "${var.user_sshkey}"
  }
}

data "template_file" "cloud-config-bootstrap-sh" {
  template = "${file("${path.module}/etc/cloud-config-bootstrap.sh")}"
  vars {
    cjdns_commit = "${var.cjdns_commit}"
    ipfs_version = "${var.ipfs_version}"
    hostname = "${var.hostname}"
  }
}

data "template_cloudinit_config" "node-userdata" {
  gzip          = false   # cloud-init bug seems to prevent this from being enabled as at 2017-12
  base64_encode = false   #

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-config.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.cloud-config-bootstrap-sh.rendered}"
    filename     = "cloud-config-bootstrap.sh"
  }

}

# digitalocean_droplet
# ============================================================================
resource "digitalocean_droplet" "droplet_node" {
  image  = "${var.image}"
  name   = "${var.hostname}"
  region = "${var.region}"
  size   = "${var.size}"
  backups = "${var.backups}"
  monitoring = "${var.monitoring}"
  ipv6 = "${var.ipv6}"
  private_networking = "${var.private_networking}"
  //ssh_keys = [ "0" ]
  user_data = "${data.template_cloudinit_config.node-userdata.rendered}"
}

# NB: there is a very strong temptation to use floating_ip addresses here, as at
#     writing (2017-12-30) the Terraform exposed Digital Ocean interface does not
#     provide the right functionality to correctly implement static IPv4
#     addresses without clobbering (hence loosing) them.  If you require static
#     IPv4 addresses you'll need to use the Digital Ocean webui manually.


# push-cjdns-config
# ============================================================================
resource "null_resource" "push-cjdns-config-sh" {
  triggers {
    droplet_node_id = "${digitalocean_droplet.droplet_node.id}"
    cjdroute_config_sha1= "${sha1(file(var.cjdroute_config))}"
  }
  provisioner "local-exec" {
    command = "${path.module}/etc/push-cjdns-config.sh ${var.cjdroute_config} ${digitalocean_droplet.droplet_node.ipv4_address}"
  }
  depends_on = [ "digitalocean_droplet.droplet_node" ]
}
