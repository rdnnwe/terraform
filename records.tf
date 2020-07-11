module "records" {
    source  = "terraform-aws-modules/route53/aws//modules/records"
    zone_id = var.zone_id
    
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
