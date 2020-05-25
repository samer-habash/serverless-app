resource "aws_s3_bucket_notification" "notify_to_lambda" {
  bucket = data.aws_s3_bucket.s3-bucket.id
  depends_on = [aws_lambda_function.lambda-LinesCount]
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-LinesCount.arn
    // below event means  : all objecct create event
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "data/"
  }
}