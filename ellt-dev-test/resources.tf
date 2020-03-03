resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_key_pair" "ellt_dev_test" {
  key_name = "ellt_dev_test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw8I50PwYiBwbsMPTduunQSnyT58BLkhWDOzUICpaO3jhX3+KY8xmiWzEa/iMeCJy/Wa2W0lXC0h0/CNWG3QNC5DX4wVBng3guR+wPX4FzCN01H0qtiIc/leXN9hmO2Bz0F1A3IM9OkQmcE6JZIWjdMRufNY33pydzxndVZyZJ7hgGlkSYt1xweDkVwCAQDPMoO0KvIgFR84K+ny9q0EHqRwenm/zqfHkbCZHEluRNrGM5Fh/V4ZlfNrTaxuvQaPsO3GgIHN4szA6DP5ZRWQ9E2DV29cfbK1fut+p2HhMV3iu7qLsT289k7M8w2+OqBcV08eoW9kTpgIgRLRV0cwQ4olXm3PLGvns10ofLre9A0/sAo2dKces490JcSc/JL+9JExbxj2gwYhtDEYN+49iWKmkehNBdwvObU0iN3lP6/WZjlJBUrUysN4GeXPZcr5plX38xmd1IUbfwW8gs+bibaFLAfBbw5kRznL/GnMTo34xlwRCi9JJGuTIkQPAcX7rtUxUmASDvT/VuO0puB1m2LgpoI16Rn+PAHWRo2K/+BjJFgttMYTbqm04CHTeNBl24qMi2neklFSNol7PifTcWv76PkLGKjmw6eqPf8LXC5NzYYCMwHdluayFOfw2ewV8a6FhhY2wlPCId9r0nkbCt73Sxfe/RK0wYY3077kv1RQ== yangjs@lotte.net"
}

resource "aws_security_group" "test_pub_sg" {
  name = "test_pub_sg"
  description = "Test Security Group for Public"
  vpc_id = aws_vpc.test_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test_pub" {
  ami = "ami-0f02b24005e4aec36"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ellt_dev_test.key_name
  subnet_id = aws_subnet.test_subnet.id
  vpc_security_group_ids = [
    aws_security_group.test_pub_sg.id
  ]
}

output "test_pub_instance_arn" {
  value = aws_instance.test_pub.arn
}
