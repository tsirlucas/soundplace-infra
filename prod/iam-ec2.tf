resource "aws_iam_role" "kubernetes_etcd" {
  name = "kubernetes-etcd"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [ { "Effect": "Allow", "Principal": { "Service": "ec2.amazonaws.com" }, "Action": "sts:AssumeRole" } ]
}
EOF
}

resource "aws_iam_role_policy" "kubernetes_etcd" {
  name = "kubernetes-etcd"
  role = "${aws_iam_role.kubernetes_etcd.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    { "Action" : ["ec2:*"], "Effect": "Allow", "Resource": ["*"] },
    { "Action" : ["elasticloadbalancing:*"], "Effect": "Allow", "Resource": ["*"] },
    { "Action": "route53:*", "Effect": "Allow",  "Resource": ["*"] },
    { "Action": "ecr:*", "Effect": "Allow", "Resource": "*" }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "kubernetes_etcd" {
  name = "kubernetes-etcd"
  role = "${aws_iam_role.kubernetes_etcd.name}"
}
