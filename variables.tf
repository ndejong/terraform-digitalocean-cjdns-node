
# required variables - no defaults
# ============================================================================

variable "hostname" {
  description = "Required - the hostname applied to this cjdns-node droplet"
}

variable "region" {
  description = "Required - the digitalocean region to start this cjdns-node within"
}

variable "cjdroute_config" {
  description = "Required - the local cjdroute.conf file to push to this cjdns-node droplet"
}

# required variables - with defined default values
# ============================================================================

variable "image" {
  description = "Required - the digitalocean image to use as the base for this cjdns-node"
  default = "ubuntu-16-04-x64"
}

variable "size" {
  description = "Required - the digitalocean droplet size to use for this cjdns-node"
  default = "1gb"  # 1gb = $10 with 2TB bandwidth per/month as at 2017-12
}

variable "backups" {
  description = "Required - enable/disable droplet backup functionality on this cjdns-node"
  default = false
}

variable "monitoring" {
  description = "Required - enable/disable droplet monitoring functionality on this cjdns-node"
  default = true
}

variable "ipv6" {
  description = "Required - enable/disable IPv6 functionality on this cjdns-node"
  default = true
}

variable "private_networking" {
  description = "Required - enable/disable private-networking functionality on this cjdns-node"
  default = true
}

variable "cjdns_commit" {
  description = "Required - the commit sha1 to download from github.com/cjdelisle/cjdns then build and install on this cjdns-node"
  default = "efd7d7f82be405fe47f6806b6cc9c0043885bc2e"
  # https://github.com/cjdelisle/cjdns/releases
  #  - crashy = 0a08d0812976548ce12db9d80a9c0033fb8a14fc @ 2018-01-10
  #  - v20    = efd7d7f82be405fe47f6806b6cc9c0043885bc2e
  #  - v19.1  = f4f73cdc120907f9952f7c74abe68394fd2879a0
  #  - v19    = 63fdd890d7b9903e386ae094fe4ace548d3988f6
  #  - v18    = 6781eddb2b206da6d9e14fa79fab507c9f154acf
}

# optional variables
# ============================================================================

variable "user" {
  description = "Optional - the user initial login user to create with passwordless sudo access for this cjdns-node, if empty no account will be created - the root account is always disabled"
  default = ""
}

variable "user_sshkey" {
  description = "Optional - the sshkey to apply to the initial user account - password based auth is always disabled"
  default = ""
}

variable "ipfs_version" {
  description = "Optional - if set will additionally install IPFS on this cjdns-node - without any configuration!"
  default = ""  # fragile, depends on upstream tarball - empty string means do not install
  # https://dist.ipfs.io/go-ipfs/versions
  # - v0.4.13  @ 2017-10-16
}
