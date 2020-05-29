- This directory is a to complete the word done from before with openfaas.

The python code as  do the following : 

        - checking s3 modification objects within 24 hour
        - Downloading them
        - Sending them to openfaas function wordscount-s3-objects from WORDS_COUNTER dir
        - Lastly it will send the result to AWS RDS .

Example of Usage :
    
        e.g. python s3-object-cron.py bucket_name