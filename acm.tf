module "acm" {
    source  = "terraform-aws-modules/acm/aws"

    domain_name = "nwe.group"
    subject_alternative_names = ["*.nwe.group"]
    zone_id     = "Z05830172NQEHW4JNM4HI"
}
