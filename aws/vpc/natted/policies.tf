resource "aws_iam_role" "dmz" {
  name = "${var.name}-dmz"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_describe_az" {
  name = "${var.name}-ec2_describe_az"
  description = "High-level read-only to describe region and AZ"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeAvailabilityZones",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeRegions",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeTags",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ec2_describe_az" {
  name = "${var.name}-ec2_describe_az"
  policy_arn = "${aws_iam_policy.ec2_describe_az.arn}"
  roles = [
    "${aws_iam_role.dmz.name}"
  ]
}
