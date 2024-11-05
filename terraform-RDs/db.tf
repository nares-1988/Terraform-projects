data "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-password"
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
}

resource "aws_db_subnet_group" "prod_subnet" {
  name = "prod_subnet"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
    aws_subnet.subnet2-public.id,
  ]
  tags = {
    Name = "My production subnet group"
  }
}

resource "aws_db_instance" "prod_db_instance" {
  identifier           = "proddb"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.44"
  instance_class       = "db.t3.medium"
  username             = "dbadmin"
  password             = data.aws_secretsmanager_secret_version.db_secret_version.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.prod_subnet.id
}
