locals {
  // lambda_timeout_in_seconds will be put more than 30 seconds which is the pymysql timeout timeframe.
  lambda = {
    filename = "linescounter.zip"
    function_name = "LinesCount"
    handler = "linescounter.handler"
    runtime = "python3.6"
    lambda_timeout_in_seconds = 35
  }
}