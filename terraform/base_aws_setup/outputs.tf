output "VPCIdsMap" {
  value = module.base_setup.VPCIdsMap
}

output "DevVPCId" {
  value = module.base_setup.DevVPCId
}

output "StageVPCId" {
  value = module.base_setup.StageVPCId
}

output "SubnetIdsMap" {
  value = module.base_setup.SubnetIdsMap
}

output "DevVPCCidrBlock" {
  value = module.base_setup.DevVPCCidrBlock
}

output "StageVPCCidrBlock" {
  value = module.base_setup.StageVPCCidrBlock
}

output "RouteTableIDMap" {
  value = module.base_setup.RouteTableIDMap
}

output "DevVPNSgMap" {
  value = module.base_setup.DevVPNSgMap
}

output "EcsExecutionRoleARN" {
  value = module.base_setup.EcsExecutionRoleARN
}
