
# outputs
# ============================================================================

output "hostname" {
  description = "the hostname given to this cjdns-node"
  value = "${var.hostname}"
}

output "region" {
  description = "the digitalocean region this cjdns-node is within"
  value = "${var.region}"
}

output "user" {
  description = "the user initial login user created with passwordless sudo access on this cjdns-node if set"
  value = "${var.user}"
}

output "cjdroute_config" {
  description = "the local cjdroute.conf file pused to this cjdns-node droplet"
  value = "${var.cjdroute_config}"
}

output "cjdns_commit" {
  description = "the cjdns git commit used to download, build and install on this cjdns-node"
  value = "${var.cjdns_commit}"
}

output "ipfs_version" {
  description = "the IPFS version used to download and install on this cjdns-node"
  value = "${var.ipfs_version}"
}

output "ipv4_address" {
  description = "the IPv4 address of this cjdns-node droplet"
  value = "${digitalocean_droplet.droplet_node.ipv4_address}"
}

output "ipv6_address" {
  description = "the IPv6 address of this cjdns-node droplet"
  value = "${digitalocean_droplet.droplet_node.ipv6_address}"
}
