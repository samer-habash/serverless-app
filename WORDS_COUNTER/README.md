
- This Directory "WORDS_COUNTER" is an openfaas function that gets the object in the S3 bucket and return its word length and content in text format. 
- You should invoke with the s3 bucket name + the object path/name :

                                  format = "mybucket/myfile" || "mybucket/dir/myfile" 


create your secret , such as aws credentials in the namespace : openfaas-fn (otherwise it will not catch it)
e.g. :
    faas-cli secret create sample-aws-secret --from-file=./aws_credentials_as_key_value
    or sample-aws-secret : kubectl apply -f sample-aws-secret.yml

faas-cli build -f ./wordcount-s3-objects.yml --name dockerhubuser/wordcount-s3-objects
faas-cli push -f ./wordcount-s3-objects.yml
faas-cli deploy -f ./wordcount-s3-objects.yml

Note: if you added annotations from openfaas docs the function will run with an empty string invocation, which leads to stop the function, 
    plus your deployment/pod will never be in running state.


-> Still this will not work :
since openfaas does not actually support valueFrom secrets , then I did a small trick .
    a) applied aws credentials as regular environmental "key: value" without applying the correct values (if you apply the credentials directly it is risky)
    b) faas-cli build/push
    c) Deployed the openfaas image in the dockerhub/docker-private-registry with env faulty values.
    d) Before you will invoke the function with the s3 bucket_name , edit the deployment in openfaas-fn .
       ~ kubectl edit deployments.apps -n openfaas-fn wordcount-s3-objects
       and replace the regular env with the following format as below :

       """
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: sample-aws-secret
                  key: AWS_ACCESS_KEY_ID
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
              name: sample-aws-secret
              key: AWS_SECRET_ACCESS_KEY
            AWS_DEFAULT_REGION: us-east-1
            
        """

--> You can restart the deployment if you wish , by default the pods will reconsider it :
    e.g. ~ kubectl rollout restart deployment -n openfaas-fn wordcount-s3-objects
