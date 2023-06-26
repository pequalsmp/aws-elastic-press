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

1. Configure your AWS credentials (manually or via aws-cli)
2. Clone this repo and cd into it
3. Pick a WordPress image from [DockerHub](https://hub.docker.com/_/wordpress) (the one provided in this repo is likely outdated) and update terraform.tfvars
4. Run bash build.sh
5. Run terraform plan
6. Run terraform apply 
7. Wait...
8. Visit the URL printed at the bottom
9. ...
10. Run terraform destroy to tear-down the infrastructure

# TODO

- Add tags to resources
- Generate (if possible) TLS certificate from Let's Encrypt
- Evaluate Firewall rules and narrow-down the overly permissive ones
- Evaluate and optimize cost

# WhyNot

### Use the Elastic Container Service

It's fairly straight-forward to do so. This is an example of 

### Use Lambda for periodic tasks

Same as above. Lambda is trivial to setup and 

### Build container images and deploy them, instead of user_data hacks

It's quite a hassle to build to images and you'll be billed for every pull

# Contributing

Issues/PR are welcome as long as they stay within the AWS Free Tier constraints/limitations.
