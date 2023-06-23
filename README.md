This project aims to be a learning demonstration of setting WordPress in the cloud (AWS) by utilizing [Terraform](https://www.terraform.io/docs).

Note: This is not intended for production use.

It was designed to utilize AWS Free Tier and as such it may lack high-availability or performance required for production deployments.

# Cost

The only component with no Free Tier in the project is the [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

You pay for every hour the NAT Gateway is running and for every GB that goes through an Elastic IP.

Best to keep it short and quickly destroy after deployment to minimize cost.

Future iterations may remove this dependency as even though NAT Gateways are useful in the real world, learning should be free.

# Prerequisites

- AWS Free Tier account
- Terraform installed locally

# Setup

1. Configure aws-cli
2. Pick a WordPress image you'd like to run (the one provided in this repo is likely outdated) and update terraform.tfvars
3. Run terraform plan
4. Run terraform apply 
5. Wait...
6. Visit the URL printed at the bottom
7. ...
8. Run terraform destroy

# Contributing

Issues/PR are welcome as long as they stay within the AWS Free Tier constraints/limitations.
