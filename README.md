Serverless App Project :

1. generate-files-to-s3-app:
 
        - Is a file-generator app that will randomly produce random lines+words and then upload it to S3
        - The app done via docker images , then through k8s yaml deployment .

2. DATABASE: 
        
        - Is an AWS RDS instance that will have two tables to measure the number of lines and words per each file uploaded.

3. LINES_COUNTER:
 
        - Is an aws lambda function that will trigger the S3 per each event of an uploaded object and write the calculations per file to the RDS.

4. WORDS_COUNTER: 
    
        - Is an openfaas function as a service to calculate the words per line and write the calculations per file to the RDS.

5. WORDS_COUNTER_BATCH:
    
        - Is an app for checking daily s3 objects as follows:
            a. Checks latest modified as 24 hour basis
            b. Download the file
            a. Send the contents to WORDS_COUNTER openfaas function
            b. Insert the calculations in RDS

5. VISUALIZATION_SERVICE:
 
        - Is an addon for visualyzing and monitoring the caclculations in RDS via grafana.

The Project will use : terraform, boto3,openfaas for building the serverless app in aws.

### Checklist :

   - [x] Creating-Tables-rds-boto3-pymysql
   - [x] DATABASE
   - [x] generate-files-to-s3-app
   - [x] LINES_COUNTER
   - [x] WORDS_COUNTER
   - [ ] WORDS_COUNTER_BATCH
   - [ ] VISUALIZATION_SERVICE
   
                   




