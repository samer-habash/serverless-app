- This directory is the full app process.
- The app will do the following :
   
        a. s3 changes as Daily check basis (every 24 hour) :
        b. Download the modifed/uploaded objects in s3
        c. send the object to openfaas function in WORDS_COUNTER dir to claculate word length
        d. send the result to rds  

The python code as  do the following : 

        - checking s3 modification objects within 24 hour
        - Downloading them
        - Sending them to openfaas function wordscount-s3-objects from WORDS_COUNTER dir
        - Lastly it will send the result to AWS RDS .


### Checklist :

   - [x] Python Code
   - [x] Dockerfile
   - [x] k8s YAMLs
   - [x] helm chart
