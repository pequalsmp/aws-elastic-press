resource "aws_autoscaling_group" "wordpress" {
  vpc_zone_identifier = module.vpc.private_subnets

  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  target_group_arns = [aws_alb_target_group.apache.arn]

  launch_template {
    id      = aws_launch_template.dockerized_wordpress.id
    version = aws_launch_template.dockerized_wordpress.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
  }
}

resource "aws_launch_template" "dockerized_wordpress" {
  name = "WordPress"

  description = "Image with a setup script to install efs-utils, docker and pull WordPress image from a registry"

  image_id      = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"

  user_data = base64encode(local.setup_script)
}

resource "aws_instance" "maintenance" {
  ami             = data.aws_ami.ubuntu.image_id
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [module.vpc.default_security_group_id]

  user_data_base64 = base64encode(local.maintenance_script)
}
