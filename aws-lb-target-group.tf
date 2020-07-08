resource "aws_lb_target_group_attachment" "test" {
    target_group_arn = module.alb.target_group_arns[0]
    target_id        = aws_instance.RDN_Test_TerraformInstance_01.private_ip
    port             = 80
}
