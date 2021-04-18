
from pulumi_aws import iam, get_partition


def default_iam_role(service_naming_convention, lambda_name):
    current = get_partition()

    lambda_role = iam.Role(
        lambda_name + '_' + service_naming_convention,
        assume_role_policy="""{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {
                        "Service": "lambda.amazonaws.com"
                    },
                    "Effect": "Allow",
                    "Sid": ""
                }
            ]
        }"""
    )

    iam.RolePolicyAttachment(
        lambda_name + '_' + service_naming_convention + '_default_policy',
        role=lambda_role.name,
        policy_arn=f"arn:{current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    )

    return lambda_role


def default_iam_role_vpc(service_naming_convention, lambda_name):
    current = get_partition()

    lambda_role = iam.Role(
        lambda_name + '_' + service_naming_convention + '-vpc',
        assume_role_policy="""{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {
                        "Service": "lambda.amazonaws.com"
                    },
                    "Effect": "Allow",
                    "Sid": ""
                }
            ]
        }"""
    )

    iam.RolePolicyAttachment(
        lambda_name + '_' + service_naming_convention + '_default_policy_vpc',
        role=lambda_role.name,
        policy_arn=f"arn:{current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    )

    return lambda_role
