provider "aws" {
  region                  = "eu-west-1"
}

module "vpc" {
    source = "github.com/terraform-aws-modules/terraform-aws-vpc"
    
    name = "test-vpc"
    cidr = "10.1.0.0/16"
    azs  = ["eu-west-1a", "eu-west-1b"]
    private_subnets = ["10.1.0.0/18", "10.1.128.0/18"]
    public_subnets  = ["10.1.64.0/18", "10.1.192.0/18"]
    
    enable_nat_gateway = true
    enable_dns_support = true

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "test-sg-01"
  description = "Security group for example usage with ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "acm" {
    source  = "terraform-aws-modules/acm/aws"

    domain_name = "nwe.group"
    subject_alternative_names = ["*.nwe.group"]
    zone_id     = "Z05830172NQEHW4JNM4HI"
}


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

resource "aws_instance" "RDN_Test_TerraformInstance_01" {
    ami = "ami-0ea3405d2d2522162"
    instance_type = "t1.micro"
    
    subnet_id = module.vpc.private_subnets[0]
    security_groups = [module.security_group.this_security_group_id]
    
    user_data = <<-EOF
                    #!/bin/bash -xe
                    yum install -y httpd
                    echo "<p> Hi Putin! </p>" >> /var/www/html/index.html
                    systemctl enable httpd
                    service httpd start
                  EOF
    
    tags = {
        Name = "Test_Instance_01"
        Environment = "Development"
    }
}

resource "aws_lb_target_group_attachment" "test" {
    target_group_arn = module.alb.target_group_arns[0]
    target_id        = aws_instance.RDN_Test_TerraformInstance_01.private_ip
    port             = 80
}
