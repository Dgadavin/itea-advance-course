from datetime import date
import boto3
import json
import os

bucket_name = os.getenv('BUCKET')


def main():
    store = {}
    client = boto3.client('ssm')

    paginator = client.get_paginator('describe_parameters')
    pages = paginator.paginate(MaxResults=50)

    for page in pages:
        for p in page['Parameters']:
            resp = client.get_parameter(Name=p['Name'], WithDecryption=True)
            store[resp['Parameter']['Name']] = resp['Parameter']['Value']

    s3 = boto3.client('s3')
    s3.put_object(
        Bucket=bucket_name,
        Key=str(date.today().year) + "/" + str(date.today().month) + "/" + str(date.today().day) + ".json",
        Body=json.dumps(store),
        ServerSideEncryption='aws:kms'
    )


def handler(event, context):
    main()


if __name__ == "__main__":
    main()
