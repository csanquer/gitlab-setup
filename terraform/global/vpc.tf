resource "aws_vpc" "gitlab" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "gitlab"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.gitlab.id}"

  tags {
    Name = "default"
  }
}

/********************/
/*  Public subnets */
/********************/

/*  Public subnet 1 */

resource "aws_subnet" "public1" {
  vpc_id                  = "${aws_vpc.gitlab.id}"
  cidr_block              = "${var.public1_subnet_cidr}"
  availability_zone       = "${var.aws_az1}"
  map_public_ip_on_launch = true

  tags {
    Name = "public subnet 1"
  }
}

resource "aws_route_table" "public1" {
  vpc_id = "${aws_vpc.gitlab.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "public subnet 1"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public1.id}"
}

/*  Public subnet 2 */

resource "aws_subnet" "public2" {
  vpc_id                  = "${aws_vpc.gitlab.id}"
  cidr_block              = "${var.public2_subnet_cidr}"
  availability_zone       = "${var.aws_az2}"
  map_public_ip_on_launch = true

  tags {
    Name = "public subnet 2"
  }
}

resource "aws_route_table" "public2" {
  vpc_id = "${aws_vpc.gitlab.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "public subnet 2"
  }
}

resource "aws_route_table_association" "public2" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.public2.id}"
}

/********************/
/*  Private subnets */
/********************/

/* private subnet 1 */
resource "aws_subnet" "private1" {
  vpc_id            = "${aws_vpc.gitlab.id}"
  cidr_block        = "${var.private1_subnet_cidr}"
  availability_zone = "${var.aws_az1}"

  tags {
    Name = "private subnet 1"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = "${aws_vpc.gitlab.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat1.id}"
  }

  tags {
    Name = "private subnet 1"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private1.id}"
}

/* private subnet 2 */

resource "aws_subnet" "private2" {
  vpc_id            = "${aws_vpc.gitlab.id}"
  cidr_block        = "${var.private2_subnet_cidr}"
  availability_zone = "${var.aws_az2}"

  tags {
    Name = "private subnet 2"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = "${aws_vpc.gitlab.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat2.id}"
  }

  tags {
    Name = "private subnet 2"
  }
}

resource "aws_route_table_association" "private2" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.private2.id}"
}

/* NAT Gateway between subnets */

resource "aws_eip" "nat1" {
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = "${aws_eip.nat1.id}"
  subnet_id     = "${aws_subnet.public1.id}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_eip" "nat2" {
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = "${aws_eip.nat2.id}"
  subnet_id     = "${aws_subnet.public2.id}"

  depends_on = ["aws_internet_gateway.default"]
}

/* Elastic IPs */

resource "aws_eip" "bastion1" {
  vpc        = true
  instance   = "${aws_instance.bastion1.id}"
}
