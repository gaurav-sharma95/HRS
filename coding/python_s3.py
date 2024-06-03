import csv
import boto3
import os
from redis import Redis


# AWS credentials
aws_access_key_id = 'your_aws_access_key_id'
aws_secret_access_key = 'your_aws_secret_access_key'

# Create a session using your AWS credentials
session = boto3.Session(
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name='us-west-2'  # or your preferred region
)

# Create a Redis connection
redis_client = redis.Redis(host='your_redis_endpoint', port=6379, db=0)

# Get all keys and values from Redis
keys = redis_client.keys()
data = {key: redis_client.get(key) for key in keys}

# Write data to a CSV file
with open('data.csv', 'w', newline='') as csvfile:
    fieldnames = ['key', 'value']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for key, value in data.items():
        writer.writerow({'key': key, 'value': value})

# Create an S3 client
s3 = session.client('s3')

# Upload the CSV file to S3
with open('data.csv', 'rb') as data:
    s3.upload_fileobj(data, 'your-bucket-name', 'data.csv')

# Remove the local CSV file
os.remove('data.csv')
