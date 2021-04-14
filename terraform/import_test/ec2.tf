resource "aws_instance" "example" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"

  tags = {
    Name = "test-import"
  }
}

# terraform init
# terraform import aws_instance.example <instance_id>
