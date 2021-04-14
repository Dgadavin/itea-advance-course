resource "aws_security_group" "openvpn_dev" {
  name        = "allow_openvpn_dev"
  description = "Allow traffirc from OpenVPN network"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "openvpn_stage" {
  name        = "allow_openvpn_stage"
  description = "Allow traffirc from OpenVPN network"
  vpc_id      = aws_vpc.stage_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

