resource "aws_instance" "RDN-Test-TerraformInstance-01" {
    ami = var.ec2_ami
    instance_type = var.ec2_instance_type
    
    subnet_id = module.vpc.private_subnets[0]
    security_groups = [module.security_group.this_security_group_id]
    
    user_data = <<-EOF
                    #!/bin/bash -xe
                    yum install -y httpd
                    echo "<p> Hi Putin! </p>" >> /var/www/html/index.html
                    systemctl enable httpd
                    service httpd start
                  EOF
    
    tags = merge(
        local.common_tags,
        { 
            Name = "test-Terraform-Instance"
        }
    )
}