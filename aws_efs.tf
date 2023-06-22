resource "aws_efs_file_system" "www" {
  creation_token = "www"
}

resource "aws_efs_mount_target" "www01" {
  file_system_id = aws_efs_file_system.www.id
  subnet_id      = module.vpc.private_subnets[0]
}

resource "aws_efs_mount_target" "www02" {
  file_system_id = aws_efs_file_system.www.id
  subnet_id      = module.vpc.private_subnets[1]
}
