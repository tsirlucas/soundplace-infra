resource "aws_launch_template" "soundplace_workers" {
  name_prefix            = "soundplace-worker"
  image_id               = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "soundplace_workers_group" {
  name                      = "soundplace-workers"
  availability_zones        = ["${data.aws_availability_zones.available.names[1]}"]
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  health_check_type         = "EC2"
  health_check_grace_period = 2000
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]

  launch_template = {
    id      = "${aws_launch_template.soundplace_workers.id}"
    version = "$$Latest"
  }
}
