module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "test-sg-01"
  description = "Security group for example usage with ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  
  tags = merge(
      local.common_tags,
      { 
          Name = "Test-Security-Group"
      }
  )
}
