The app generates a random file and upload it to S3 bucket.

This app has a docker image that is dynamic and has the following arguments :

    App Usage :
        Please Pass the following input parameters :
            1. flag -b : Bucket S3 name
            2. flag -d : Directory to be stored on S3
            3. flag -f : filename to be produced
            4. flag -l : integer number to specify the maximum number of lines per file
            5. flag -w : integer number to specify the maximum number of words per line
            NOTE that the file will be randomly generated from produce_file() function

- The app has a Debian-slim-buster image which is a good and small os for python applications performance.

- The app removes the file after it is being uploaded and verified that the upload is successful.
  it also validates the size in the aws s3 and the the file created inside the docker.
  
- The app will then removes the file from the container volume.

- With some manipulations this app is dynamic for transferring files form any server to any S3 buckets.

The directory k8s_yaml_app_creation consists of the k8s deployment to the app.

    - Please check the args being passed and modify them as per your request.
