resource "aws_efs_file_system" "efs" {
  creation_token = "${local.cluster_name}-efs"

  tags = {
    Name = "${local.cluster_name}-efs"
  }
}

#resource "aws_efs_mount_target" "efs" {
#  count = 2
#  file_system_id = aws_efs_file_system.efs.id
#  subnet_id = aws_subnet.this.*.id[count.index]
#  security_groups = [module.eks.cluster_security_group_id]
#}