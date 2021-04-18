
import os
import mimetypes
from pulumi_aws import lambda_, cloudwatch, iam, s3
from pulumi import export, Config, FileAsset
import iam as default_iam


LAMBDA_BUCKET = "sotnikov-itea-tf-states"
LAMBDA_SOURCE = 'delete_old_amis.py'
LAMBDA_PACKAGE = 'lambda.zip'
LAMBDA_VERSION = '1.0.0'
os.system('zip %s %s' % (LAMBDA_PACKAGE, LAMBDA_SOURCE))

project_conf = Config('proj')
cleanup_amis_conf = Config('cleanup_amis')

appname = project_conf.require('appname')
env = project_conf.require('env')
dc = project_conf.require('dc')
runtime = project_conf.require('runtime')
service_naming_convention = f"{appname}-{dc}-{env}"
lambda_name = "cleanup_old_amis"

# Upload Lambda function to the S3 bucket
mime_type, _ = mimetypes.guess_type(LAMBDA_PACKAGE)
obj = s3.BucketObject(
            LAMBDA_VERSION+'/'+LAMBDA_PACKAGE,
            bucket=LAMBDA_BUCKET,
            source=FileAsset(LAMBDA_PACKAGE),
            content_type=mime_type
            )

lambda_role = default_iam.default_iam_role(service_naming_convention, lambda_name)

iam.RolePolicy(
    service_naming_convention + '-cleanup-old-amis-policy',
    role=lambda_role.id,
    policy="""{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowCleanupAMIs",
                "Effect": "Allow",
                "Action": [
                    "ec2:DescribeImages",
                    "ec2:DescribeImageAttribute",
                    "ec2:DeregisterImage"
                ],
                "Resource": "*"
            }
        ]
    }"""
)

cleanup_old_amis = lambda_.Function(
    service_naming_convention + '_' + lambda_name,
    s3_bucket=LAMBDA_BUCKET,
    s3_key=LAMBDA_VERSION+'/'+LAMBDA_PACKAGE,
    handler="delete_old_amis.handler",
    runtime=runtime,
    role=lambda_role.arn,
    environment=lambda_.FunctionEnvironmentArgs(
        variables={
            "APP": service_naming_convention + "-app_",
            "AMI_LIMIT": cleanup_amis_conf.require('ami_limit')
        }
    ),
    tags={
        "Name": service_naming_convention + "-" + lambda_name,
        "Application": appname,
        "Description": "Lambda to cleanup old AMIs for ASG",
        "Environment": env,
        "Role": "Lambda",
        "Pulumi": "True"
    }
)

event_rule = cloudwatch.EventRule(
    service_naming_convention + "-cleanup_old_amis-rule",
    name=service_naming_convention + '-cleanup-old-amis-event',
    description="This is lambda for cleanup old amis",
    schedule_expression="cron(0 3 ? * SUN *)"
)

cloudwatch.EventTarget(
    service_naming_convention + "-cleanup-old-amis-target", arn=cleanup_old_amis.arn, rule=event_rule.name
)

lambda_.Permission(
    service_naming_convention + "-cleanup-old-amis-permission",
    action="lambda:InvokeFunction",
    function=cleanup_old_amis.name,
    principal="events.amazonaws.com",
    source_arn=event_rule.arn
)

export('lambda_name',  cleanup_old_amis.id)
export('bucket_name',  LAMBDA_BUCKET)
