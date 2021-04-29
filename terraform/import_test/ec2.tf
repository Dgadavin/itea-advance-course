resource "aws_instance" "example" {
  ami           = "ami-0ffea00000f287d30"
  instance_type = "t2.micro"
  #
  tags = {
    Name = "test-import"
  }
}

# terraform init
# terraform import aws_instance.example <instance_id>
