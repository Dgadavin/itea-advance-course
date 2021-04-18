# Deploy Lambda with Pulumi

This is simple example how to deploy lambda function with Pulumi

```bash
export AWS_DEFAULT_REGION=eu-west-1
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
cd pulumi_old_amis
pulumi login s3://<s3-bucket-for-states>
pulumi stack init
pulumi up
pulumi logs -f
pulumi destroy
```
