import boto3
from PIL import Image
import io
import os
import sys

def list_files(bucket):
    s3 = boto3.client('s3')
    return s3.list_objects_v2(Bucket=bucket)['Contents']

def check_transparency(image):
    if image.mode in ("RGBA", "LA"):
        alpha = image.getchannel('A')
        return any(alpha.getdata())  # Check if any transparency exists
    return False

def transfer_images(source_bucket, destination_bucket, log_path):
    s3 = boto3.resource('s3')
    for item in list_files(source_bucket):
        try:
            file_key = item['Key']
            obj = s3.Object(source_bucket, file_key)
            img_data = obj.get()['Body'].read()
            image = Image.open(io.BytesIO(img_data))

            if not check_transparency(image):
                s3.meta.client.copy({'Bucket': source_bucket, 'Key': file_key}, destination_bucket, file_key)
            else:
                with open(log_path, 'a') as log_file:
                    log_file.write(f"{file_key} has transparency\n")
        except Exception as e:
            print(f"Error processing {file_key}: {str(e)}")

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Usage: python script.py <source_bucket> <destination_bucket> <log_file>")
        sys.exit(1)

    source_bucket = sys.argv[1]
    destination_bucket = sys.argv[2]
    log_path = sys.argv[3]
    transfer_images(source_bucket, destination_bucket, log_path)

