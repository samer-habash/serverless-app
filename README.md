Serverless App Project :

1. File-generator app that will randomly produce random lines+words and then upload it to S3
   - The app done via docker images , then through k8s yaml deployment .

2. AWS RDS instance that will have two tables to measue the number of lines and words per each file uploaded.

3. LinesCounter aws lambda function that will trigger the S3 per each event of an uploaded object and write the calculations per file to the RDS.

4. WordsCount openfaas function as a service to calculate the words per line and write the calculations per file to the RDS.

5. Monitoring tools like grafana

The App will use : terraform, boto3 for building the serverless app in aws.


