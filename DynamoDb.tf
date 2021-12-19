resource "aws_dynamodb_table" "UserScore-dynamodb-table" {
  name           = "UserScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
  
  tags = {
    Name        = "UserScores01"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table_item" "Item1" {
  depends_on = [
    aws_dynamodb_table.UserScore-dynamodb-table
  ]
  table_name = aws_dynamodb_table.UserScore-dynamodb-table.name
  hash_key   = aws_dynamodb_table.UserScore-dynamodb-table.hash_key

  item = <<ITEM
  {
    "UserId": {"S": "12345"},
    "Subject": {"S": "Mathematics"},
    "Score": {"N": "84.5"}
  }
  ITEM
}