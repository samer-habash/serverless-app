import os
import sys
import logging
from pathlib import Path
import argparse
import s3_resource
from python_generate_files import produce_file


def help():
    print("""
    App Usage :
        Please Pass the following input parameters :
            1. flag -b : Bucket S3 name
            2. flag -d : Directory to be stored on S3
            3. flag -f : filename to be produced
            4. flag -l : integer number to specify the maximum number of lines per file
            5. flag -w : integer number to specify the maximum number of words per line
            NOTE that the file will be randomly generated from produce_file() function
""")


if __name__ == '__main__':
    if len(sys.argv[1:]) == 0:
        help()
    else:
        while True:
            parser = argparse.ArgumentParser(description='Added flags for lines and words')
            parser.add_argument("-b", "--bucket_name", action="store", type=str)
            parser.add_argument("-d", "--data_dir_store", action="store", type=str)
            parser.add_argument("-f", "--filename", action="store", type=str)
            parser.add_argument("-l", "--lines", action="store", type=int)
            parser.add_argument("-w", "--words", action="store", type=int)
            args = parser.parse_args()
            bucket_name = args.bucket_name
            choose_filename = args.filename
            data_dir_store = args.data_dir_store
            lines_count = args.lines
            words_per_line = args.words

            file_produced = produce_file(choose_filename, data_dir_store, lines_count, words_per_line)
            file_name_produced = file_produced[1]
            file_name_produced_path = Path(file_name_produced).resolve()
            file_name_produced_size = Path(file_name_produced_path).stat().st_size
            s3 = s3_resource.boto3.client('s3')
            buckets = s3.list_buckets()
            if bucket_name not in buckets:
                logging.info("Bucket " + bucket_name + "will be created ! ")
                s3_resource.create_bucket(bucket_name)
                upload_file = s3_resource.upload_file_to_s3(file_name_produced, bucket_name, file_name_produced)
                uploaded_file_size = s3_resource.check_uploaded_file_size(bucket_name, file_name_produced)
                if upload_file is True and uploaded_file_size == file_name_produced_size:
                    logging.info("Object " + file_name_produced + " has been uploaded successfully ! ")
                    os.remove(file_name_produced_path)
                    logging.info("Object " + file_name_produced + " has been removed from docker volume ! ")
            else:
                upload_file = s3_resource.upload_file_to_s3(file_name_produced, bucket_name, file_name_produced)
                uploaded_file_size = s3_resource.check_uploaded_file_size(bucket_name, file_name_produced)
                if upload_file is True and uploaded_file_size == file_name_produced_size:
                    logging.info("Object " + file_name_produced + " has been uploaded successfully ! ")
                    os.remove(file_name_produced_path)
                    logging.info("Object " + file_name_produced + " has been removed from docker volume ! ")
