# Terraform + Digital Ocean + cjdns

Terraform module to create a cjdns node and push locally managed cjdroute.conf files
 * [cjdns](https://github.com/cjdelisle/cjdns) / [hyperboria](https://hyperboria.net/)
 * [digital ocean](https://www.digitalocean.com/)

## Usage

```hcl
module "node0-sfo2-digitalocean" {
  source = "../../modules/terraform-digitalocean-cjdns-node"
  size = "512mb"
  region = "sfo2"
  hostname = "node0-sfo2-digitalocean"
  user = "${var.user}"
  user_sshkey = "${var.user_sshkeys["${var.user}"]}"
  cjdns_commit = "0a08d0812976548ce12db9d80a9c0033fb8a14fc"  # crashy @ 2018-01-10
  cjdroute_config = "${path.cwd}/../../data/cjdroute/node0-sfo2-digitalocean.json"
}
```  

## Authors
Module managed by [Nicholas de Jong](https://github.com/ndejong).

## License
Apache 2 Licensed. See LICENSE for full details.
