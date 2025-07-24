# Create a security group allowing SQL Server access (port 1433)
resource "aws_security_group" "sql_sg" {
  name        = "sql-server-sg"
  description = "Allow SQL Server access"
  vpc_id      = "vpc-0e3cc4252fefe4eee" # Replace with your VPC ID

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with more restrictive CIDR for production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group (replace subnet IDs)
resource "aws_db_subnet_group" "sql_subnet_group" {
  name       = "sql-subnet-group"
  subnet_ids = ["subnet-0eae5e5496107de51", "subnet-0b133bc169974a958"]

  tags = {
    Name = "SQL Subnet Group"
  }
}

# Create RDS SQL Server instance
resource "aws_db_instance" "sql_server" {
  identifier              = "sql-server-db"
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.4073.23.v1" # You can change this to latest supported
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "adminuser"
  password                = "SecurePassw0rd!"
  db_name                 = "mydatabase"
  vpc_security_group_ids  = [aws_security_group.sql_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.sql_subnet_group.name
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = false

  tags = {
    Name = "SQL Server DB"
  }
}