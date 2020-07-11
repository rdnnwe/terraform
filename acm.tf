module "acm" {
    source  = "terraform-aws-modules/acm/aws"

    domain_name = "nwe.group"
    subject_alternative_names = ["*.nwe.group"]
    zone_id     = var.zone_id
}
