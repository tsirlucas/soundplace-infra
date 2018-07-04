resource "aws_instance" "etcd_instance" {
  ami               = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type     = "t2.micro"
  subnet_id         = "${module.vpc.public_subnets[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Description = "etcd instance"
  }
}

resource "aws_ebs_volume" "etcd_volume" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  size              = 40

  tags {
    Name = "etcd-volume"
  }
}

resource "aws_volume_attachment" "volumes-attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.etcd_volume.id}"
  instance_id = "${aws_instance.etcd_instance.id}"
}
