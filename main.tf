provider "aws" {
  profile = "default"
  region = "var.region"
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
