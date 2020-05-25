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

resource "aws_iam_role_policy" "Allow_S3_KMS" {
  name = "lambda-Allow-S3-with-KMS"
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
      "Sid": "BucketAccess",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "${data.aws_s3_bucket.s3-bucket.arn}/*"
      ]
    },
    {
      "Sid": "BucketContentsAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${data.aws_s3_bucket.s3-bucket.arn}/*"
      ]
    }
  ]
}
EOF
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy" "Allow_read_secretManager" {
  name = "lambda-Allow-secretManager"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "${data.aws_secretsmanager_secret.rds_creds.arn}"
      ]
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
    role   = aws_iam_role.iam_for_lambda.id
}

// Info on authenticate-connection-rds
//"arn:aws:rds-db:<region>:<account_id>:dbuser:<rds-resource-id>/<dbuser>"
// if the last word <dbuser> is start that means for all users in database rds
resource "aws_iam_role_policy" "authenticate-connect-rds" {
  name = "lambda-Allow-auth-rds"
  //"arn:aws:rds-db:us-east-1:399728276788:dbuser:db-57JJX2KLGYXSPXZMRJIMYIABC4/sam"
  //"arn:aws:rds-db:${module.rds.current-region}:&${module.rds.aws_account_id}:dbuser:&${module.rds.rds-instance-resourceId}/&${module.rds.rds-dbuser}""
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
              "arn:aws:rds-db:us-east-1:399728276788:dbuser:db-57JJX2KLGYXSPXZMRJIMYIABC4/sam"
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
            "Action": "rds:DescribeDBInstances",
            "Resource": "*"
        }
    ]
}
EOF
  role = aws_iam_role.iam_for_lambda.id
}
