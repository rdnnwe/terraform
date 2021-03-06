module "alb" {
    source = "terraform-aws-modules/alb/aws"

    name = "test-lb"
    load_balancer_type = "application"
    
    security_groups = [module.security_group.this_security_group_id]
    
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.public_subnets
    
    target_groups = [
        {
            name_prefix      = "def"
            backend_protocol = "HTTP"
            backend_port     = 80
            target_type      = "ip"
        }
    ]
    
    http_tcp_listeners = [
        {
            port               = 80
            protocol           = "HTTP"
            target_group_index = 0
        }
    ]
    
    https_listeners = [
       {
       port               = 443
           protocol           = "HTTPS"
            certificate_arn    = module.acm.this_acm_certificate_arn
            target_group_index = 0
            ssl_policy="ELBSecurityPolicy-TLS-1-1-2017-01"
       }
    ]    
    
    tags = {
        Environment = "dev"
    }
}
