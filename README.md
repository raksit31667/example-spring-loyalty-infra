# example-spring-loyalty-infra

[![Build status](https://badge.buildkite.com/81f0996a23462ca2c52b58783d7d41aa15f932494ab6205f7a.svg)](https://buildkite.com/raksit31667/example-spring-loyalty-infra)

Example AWS infrastructure provisioning
for [example-spring-loyalty](https://github.com/raksit31667/example-spring-loyalty)
powered by AWS Cloudformation.

## Prerequisites

- [AWS CloudFormation Linter](https://github.com/aws-cloudformation/cfn-lint)
- AWS account with admin access

### Setup guides

1. Launch and run Elastic CI Stack for AWS by following
   the [instructions](https://buildkite.com/docs/tutorials/elastic-ci-stack-aws).
2. Create IAM role for `arn:aws:iam::<aws-account-id>:role/ExampleSpringLoyaltyInfra` with `AdministratorAccess`
   policy to perform Cloudformation manually.
3. Add `arn:aws:iam::<aws-account-id>:role/buildkite-Role` to trust relationship.
4. For AWS RDS bastion host, create a EC2 keypair as we will use private key to access AWS RDS DB instance.

### Access EKS cluster

1. Create a EC2 keypair as we will use private key to access EKS SSH via EC2 instance.

```shell
$ sudo ssh -i path/to/eks-private-key.pem ec2-user@ec2-xx-xx-xxx-xxx.ap-southeast-1.compute.amazonaws.com
```

2. After EKS is provisioned, access EKS by using command:

```shell
$ aws eks update-kubeconfig --name <cluster-name>
```

3. If you are using `aws-vault`, modify `~/.kube/config` file by replacing this snippets:

```yaml
apiVersion: client.authentication.k8s.io/v1alpha1
args:
  - "exec"
  - "<aws-vault-name>"
  - "--"
  - aws
  - eks
  - --region
  - ap-southeast-1
  - get-token
  - --cluster-name
  - <cluster-name>
command: aws-vault
```

## Directory structure

Here is the basic skeleton for this repository:

```
├── .buildkite
├── stack-1
│   ├── template.yml
├── stack-2
│   ├── template.yml
├── deploy.sh
```

- The [Buildkite](https://buildkite.com/) CICD pipeline script can be found beneath the `.buildkite` directory.
- The build step specifications are based from `deploy.sh`.
- We separate each AWS Cloudformation stack into folders with template underneath. Refer
  to [AWS Cloudformation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) for
  template definition.

## Installing Git hooks

```shell
$ git config --local core.hooksPath .githooks
```