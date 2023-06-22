locals {
  aws = {
    azs  = slice(data.aws_availability_zones.current.names, 0, 2)
    cidr = "10.0.0.0/16"
    network_acls = {
      default_inbound = [
        {
          rule_number = 900
          rule_action = "allow"
          from_port   = 1024
          to_port     = 65535
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
      ]
      default_outbound = [
        {
          rule_number = 900
          rule_action = "allow"
          from_port   = 32768
          to_port     = 65535
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
      ]
      public_inbound = [
        {
          rule_number = 100
          rule_action = "allow"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
      ]
      public_outbound = [
        {
          rule_number = 100
          rule_action = "allow"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
        {
          rule_number = 140
          rule_action = "allow"
          icmp_code   = -1
          icmp_type   = 8
          protocol    = "icmp"
          cidr_block  = "10.0.0.0/16" 
        },
      ]
    }
  }

  name = "example"

  setup_script = templatefile("${path.module}/setup.sh", {
    efs = {
      id = aws_efs_file_system.www.id
    }

    wp = {
      db = {
        host   = aws_db_instance.rds01.endpoint
        user   = random_string.wp_user.result
        pass   = random_password.wp_pass.result
        name   = random_string.wp_name.result
        prefix = random_string.wp_prefix.result
      }
    }

    container = {
      tag    = var.container.tag
      digest = var.container.digest
    }
  })
}
