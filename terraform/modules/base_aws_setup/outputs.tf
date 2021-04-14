output "VPCIdsMap" {
  value = {
    "dev"   = aws_vpc.dev_vpc.id
    "stage" = aws_vpc.stage_vpc.id
  }
}

output "DevVPCId" {
  value = aws_vpc.dev_vpc.id
}

output "StageVPCId" {
  value = aws_vpc.stage_vpc.id
}

output "SubnetIdsMap" {
  value = {
    "dev"   = join(",", aws_subnet.public_dev.*.id)
    "stage" = join(",", aws_subnet.public_stage.*.id)
  }
}

output "DevVPCCidrBlock" {
  value = var.vpc_cidr_range_dev
}

output "StageVPCCidrBlock" {
  value = var.vpc_cidr_range_stage
}

output "RouteTableIDMap" {
  value = {
    "dev"   = aws_route_table.public_rt_dev.id
    "stage" = aws_route_table.public_rt_stage.id
  }
}

output "DevVPNSgMap" {
  value = {
    "dev"   = aws_security_group.openvpn_dev.id
    "stage" = aws_security_group.openvpn_stage.id
  }
}

output "EcsExecutionRoleARN" {
  value = module.ecs-execution-role.IAMRoleARN
}

