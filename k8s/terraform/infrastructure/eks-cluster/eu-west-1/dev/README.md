# Setup kubernetes cluster

Before you will run terraform please change some variables in `environment.tf`

```
hosted_zone_name        = "itea.devopsology.org"
domain_zone_id          = "Z001828634P7CJAKA3JL6"
certificate_domain_name = "*.itea.devopsology.org"
```

This is DNS settings. I can create subdomain for you like `app.devopsology.org` You need to create hosted zone in Route53 in your AWS account and give me NS servers which I will use in my AWS account to point `app` to your NS servers.

Also please change S3 bucket in `provider.tf` where to store terraform state


After this manipulation you can run:

```
terraform init
terraform plan
terraform apply
```

All infra will be created after 15-20 mins.

To get access to your cluster via `kubectl` please use AWS docs

1. Install [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
2. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
3. Get kube config `aws eks update-kubeconfig --name eks-cluster-dev --region eu-west-1`

Also you can use [kubectx](https://github.com/ahmetb/kubectx) to easy change kube config

After all manipulation please run `terraform destroy`

**This setup not use AWS Free Tier**

**approximately cost will be 0.16$ per hour**
