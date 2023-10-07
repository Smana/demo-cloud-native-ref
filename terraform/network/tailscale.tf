resource "tailscale_acl" "sample_acl" {
  acl = jsonencode({
    // Define access control lists for users, groups, autogroups, tags,
    // Tailscale IP addresses, and subnet ranges.
    // This is an unrestricted rule made for a test environment, connections are allowed from all sources to any destination
    acls = [
      {
        action = "accept"
        src    = ["*"]
        dst    = ["*:*"]
      }
    ]

    // Define users and devices that can use Tailscale SSH.
    ssh = [
      {
        action = "check"
        src    = ["autogroup:member"]
        dst    = ["autogroup:self"]
        users  = ["autogroup:nonroot", "root"]
      }
    ]

    // Allow the subnet router to advertise the VPC CIDR.
    autoApprovers = {
      routes = {
        "${module.vpc.vpc_cidr_block}" = [var.tailscale.tailnet]
      }
    }

    // https://tailscale.com/kb/1218/nextdns/#disable-sharing-device-metadata-with-nextdns
    nodeAttrs = [
      {
        target = ["*"]
        attr   = ["nextdns:no-device-info"]
      }
    ]

  })
}

resource "tailscale_dns_nameservers" "this" {
  nameservers = [
    "2a07:a8c0::9d:3ccb",                  // NextDNS nameserver https://tailscale.com/kb/1218/nextdns/
    cidrhost(module.vpc.vpc_cidr_block, 2) // https://tailscale.com/kb/1141/aws-rds/#step-3-add-aws-dns-for-your-tailnet
  ]
}

resource "tailscale_dns_search_paths" "this" {
  search_paths = [
    "${var.region}.compute.internal"
  ]
}

resource "tailscale_tailnet_key" "this" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
}

module "tailscale_subnet_router" {
  source  = "Smana/tailscale-subnet-router/aws"
  version = "1.0.2"

  region = var.region
  env    = var.env

  name     = var.tailscale.subnet_router_name
  auth_key = tailscale_tailnet_key.this.key

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnets
  advertise_routes = [module.vpc.vpc_cidr_block]

  prometheus_node_exporter_enabled = true
  ssm_enabled                      = true

  tags = var.tags

}
