resource "aws_launch_template" "soundplace_masters" {
  name_prefix            = "soundplace-master"
  image_id               = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "soundplace_masters_group" {
  name                      = "soundplace-masters"
  availability_zones        = ["${data.aws_availability_zones.available.names[1]}"]
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 2000
  load_balancers            = ["${aws_elb.kubernetes_api.name}"]
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]

  launch_template = {
    id      = "${aws_launch_template.soundplace_masters.id}"
    version = "$$Latest"
  }
}
