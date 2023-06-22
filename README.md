This project aims to be a learning demonstration of setting WordPress in the cloud (AWS) by utilizing Terraform.

Note: This is not intended for production use. It was designed for deployment on AWS Free Tier and such lacks any form of high-availability or built-in resiliency.

# Prerequisites

- AWS Free Tier account
- Terraform installed locally

# Setup

1. Setup the Environmental variables required to access AWS API.
2. Pick a WordPress image/version (the default is probably outdated)
3. Run terraform plan
4. Run terraform deploy
5. Wait
6. Visit the URL printed at the bottom

# Contributing

Issues/PR are welcome as long as they stay within the AWS Free Tier constraints/limitations.
