resource "aws_elb" "kubernetes_api" {
  name                      = "kube-api"
  subnets                   = ["${module.vpc.public_subnets[0]}"]
  security_groups           = ["${aws_security_group.kubernetes_api.id}"]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:8080/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "8080"
    instance_protocol = "http"
  }
}
