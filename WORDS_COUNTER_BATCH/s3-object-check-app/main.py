import argparse
import s3_wordcounter_app

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Added -b Flag for bucket name')
    parser.add_argument("-b", "--bucket_name", action="store", type=str)
    args = parser.parse_args()
    bucket_name = args.bucket_name
    check = s3_wordcounter_app.check_existence_bucket_name(bucket_name)
    if check is True:
        result = s3_wordcounter_app.handle(bucket_name)
        if result is not None:
            print(result)
    else:
        print(check)
