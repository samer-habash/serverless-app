resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "basic_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}


//For  lambda access permissions on AWS resources we need access to VPC :
// Then we should can assign vpc, 2 subnet regions to this lambda (aws lets you choose 2 subnets at minimum for redunduncy)
//resource "aws_iam_role_policy_attachment" "lambda_access_aws_resources" {
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
//  role       = aws_iam_role.iam_for_lambda.name
//}


resource "aws_iam_role_policy" "Allow_S3" {
  name = "lambda-Allow-S3"
  /* For resource kms to get its ARN for all keys :
  "arn:aws:kms:"${module.rds.current-region}":"${module.rds.aws_account_id}":key/*",
  OR :
  Individually as below :
  "${data.aws_kms_alias.kms-get-id.arn}"
  */
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
              "*"
            ]
        }
    ]
}
EOF
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy" "Allow_read_secretManager" {
  name = "lambda-Allow_read_secretManager"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": [
        "${data.aws_secretsmanager_secret.aws-secret-after-creation.arn}"
      ]
    }
  ]
}
EOF
    role   = aws_iam_role.iam_for_lambda.id
}

/*   No need after opening security group rds
   Info on authenticate-connection-rds
  "arn:aws:rds-db:<region>:<account_id>:dbuser:<rds-resource-id>/<dbuser>"
   if the last word <dbuser> is start that means for all users in database rds
*/
// This can be ignore because we will open the CID 0.0.0.0/0 in rds-sg
// But it is more organized to do so.
resource "aws_iam_role_policy" "authenticate-connect-rds" {
  name = "lambda-Allow-auth-rds"
  // Format :
  //"arn:aws:rds-db:${region}:${account-id}:dbuser:${rds-resource-id}/${rds-dbuser}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds-db:connect"
            ],
            "Resource": [
              "arn:aws:rds-db:${module.rds_global_vars.rds_region}:${data.aws_caller_identity.current.account_id}:dbuser:${data.aws_db_instance.rds-usage-after-creation.resource_id}/${module.rds_global_vars.rds_project_dbuser}"
            ]
        }
    ]
}
EOF
  role = aws_iam_role.iam_for_lambda.id
}


resource "aws_iam_role_policy" "allow-list-rds-instances" {
  name = "lambda-Allow-list-rds"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "rds:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
  role = aws_iam_role.iam_for_lambda.id
}
