module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.0.0"

  name = local.name
  cidr = local.aws.cidr

  azs             = local.aws.azs
  private_subnets = [for k, v in local.aws.azs : cidrsubnet(local.aws.cidr, 4, k)]
  public_subnets  = [for k, v in local.aws.azs : cidrsubnet(local.aws.cidr, 8, k + 48)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  default_vpc_enable_dns_support   = true
  default_vpc_enable_dns_hostnames = true

  default_security_group_egress  = local.aws.security_groups.egress
  default_security_group_ingress = local.aws.security_groups.ingress

  # TODO: apply proper network filtering
  # local.aws.network_acls
  manage_default_network_acl    = true
  manage_default_route_table    = true
  manage_default_security_group = true

  public_inbound_acl_rules  = concat(local.aws.network_acls["default_inbound"], local.aws.network_acls["public_inbound"])
  public_outbound_acl_rules = concat(local.aws.network_acls["default_outbound"], local.aws.network_acls["public_outbound"])

  default_network_acl_tags = {
    Name = "${local.name}-default"
  }

  default_route_table_tags = {
    Name = "${local.name}-default"
  }

  default_security_group_tags = {
    Name = "${local.name}-default"
  }
}
