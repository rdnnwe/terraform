module "vpc" {
    source = "terraform-aws-modules/terraform-aws-vpc"
    
    name = "test-vpc"
    cidr = "10.1.0.0/16"
    azs  = ["eu-west-1a", "eu-west-1b"]
    private_subnets = ["10.1.0.0/18", "10.1.128.0/18"]
    public_subnets  = ["10.1.64.0/18", "10.1.192.0/18"]
        
    enable_nat_gateway = true
    enable_dns_support = true

    tags = merge(
        local.common_tags,
        { 
            Name = "Test-VPC"
        }
    )
}
