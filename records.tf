module "records" {
    source  = "terraform-aws-modules/route53/aws//modules/records"
    zone_id = "Z05830172NQEHW4JNM4HI"
    
    records = [
        {
            name    = "demo"
            type    = "A"
            alias   = {
                name    = module.alb.this_lb_dns_name
                zone_id = module.alb.this_lb_zone_id
            }
        }
    ]
}
