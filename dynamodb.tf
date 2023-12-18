resource "aws_dynamodb_table" "robotdreams_users_table" {
  name           = "robotdreams_dynamobd_users_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

}