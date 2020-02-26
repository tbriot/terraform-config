provider "aws" {
  version = "~> 2.0"
  region  = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket = "tbriot-bucket"
    key    = "terraform-backend/terraform.tfstate"
    region = "ca-central-1"
  }
}

resource "aws_launch_configuration" "launch_conf" {
  name          = "tbriot-launch-${terraform.workspace}"
  # Amazon Linux 2 AMI (HVM)
  image_id      = "ami-00db12b46ef5ebc36"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "tbriot-asg-${terraform.workspace}"
  launch_configuration = aws_launch_configuration.launch_conf.name
  min_size             = 1
  max_size             = 10
  desired_capacity     = 3
  vpc_zone_identifier = ["subnet-0623c9d501ae9e744", "subnet-0e6e35303cf133db6"]

  lifecycle {
    create_before_destroy = true
  }
}