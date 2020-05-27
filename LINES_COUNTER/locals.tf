locals {
  lambda = {
    filename = "linescounter.zip"
    function_name = "LinesCount"
    handler = "linescounter.handler"
    runtime = "python3.6"
    lambda_timeout_in_seconds = 30
  }
}