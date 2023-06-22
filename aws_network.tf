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

  # TODO: apply proper network filtering
  # local.aws.network_acls
  manage_default_network_acl    = true
  manage_default_route_table    = true
  manage_default_security_group = true

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
