resource "aws_lambda_function" "lambda-LinesCount" {
  filename = "linescounter.zip"
  function_name = "LinesCount"
  // The filename.handler-method value in your function. For example, "main.handler" calls the handler method defined in main.py.
  handler = "linescounter.handler"
  // role = aws_iam_role.iam_for_lambda.arn
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "python3.6"
  source_code_hash = filebase64sha256("linescounter.zip")
  /*vpc_config {
    security_group_ids = [module.rds.default-sg, module.rds.rds-sg]
    subnet_ids = [module.rds.subnet1, module.rds.subnet2]
  }*/
}

resource "aws_lambda_permission" "allow_bucket_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-LinesCount.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.s3-bucket.arn
}

resource "aws_s3_bucket_notification" "allow_s3_bucket_notification" {
  bucket = data.aws_s3_bucket.s3-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-LinesCount.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "data/"
  }
  depends_on = [aws_lambda_permission.allow_bucket_lambda]
}