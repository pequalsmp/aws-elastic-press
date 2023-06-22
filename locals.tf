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
        {
          rule_number     = 140
          rule_action     = "allow"
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          ipv6_cidr_block = "::/0"
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
        {
          rule_number     = 150
          rule_action     = "allow"
          from_port       = 90
          to_port         = 90
          protocol        = "tcp"
          ipv6_cidr_block = "::/0"
        },
      ]
    }

    security_groups = {
      ingress = [
        {
          cidr_blocks = "0.0.0.0/0"
          description = "HTTP"
          self        = true
          protocol    = "tcp"
          from_port   = 22
          to_port     = 22
        },{
          cidr_blocks = "0.0.0.0/0"
          description = "HTTP"
          self        = true
          protocol    = "tcp"
          from_port   = 80
          to_port     = 80
        },{
          cidr_blocks = "0.0.0.0/0"
          description = "HTTP"
          self        = true
          protocol    = "tcp"
          from_port   = 2049
          to_port     = 2049
        },{
          cidr_blocks = "0.0.0.0/0"
          description = "HTTP"
          self        = true
          protocol    = "tcp"
          from_port   = 3306 
          to_port     = 3306
        },
      ],
      egress = [
        {
          from_port   = 0
          to_port     = 0
          cidr_blocks = "0.0.0.0/0"
        }
      ]
    }
  }

  name = "wordpress"

  setup_script = templatefile("${path.module}/setup.sh", {
    container = {
      digest = var.container.digest
    }

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
  })
}
