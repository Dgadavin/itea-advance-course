import boto3
import os

app_name = os.environ['APP']
ami_limit = os.getenv('AMI_LIMIT', 10)

ec2client = boto3.client('ec2')


def getImages():
    amis = ec2client.describe_images(Owners=['self'], Filters=[
        {
            'Name': 'name',
            'Values': [app_name + '*']
        },
    ])
    return (amis)


def handler(event, context):
    amis = {}
    for v in getImages()['Images']:
        amis[v['CreationDate']] = v['ImageId']
    i = 1
    for a in sorted(amis.items(), reverse=True):
        ami_id = a[1]
        if i > ami_limit:
            print(ami_id)
            print(ec2client.deregister_image(ImageId=ami_id))
        i += 1
