resource "aws_security_group" "kubernetes" {
  vpc_id = "${module.vpc.vpc_id}"
  name   = "kubernetes"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all internal
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  # Allow all traffic from the API ELB
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.kubernetes_api.id}"]
  }
}

resource "aws_security_group" "kubernetes_api" {
  vpc_id = "${module.vpc.vpc_id}"
  name   = "kubernetes-api"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
