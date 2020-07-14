locals {
    environment = "Development"

    common_tags = {
        Terraform = "true"
        Environment = local.environment
    }
}

