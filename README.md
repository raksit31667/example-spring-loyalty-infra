# example-spring-loyalty-infra

[![Build status](https://badge.buildkite.com/81f0996a23462ca2c52b58783d7d41aa15f932494ab6205f7a.svg)](https://buildkite.com/raksit31667/example-spring-loyalty-infra)

Example AWS infrastructure provisioning
for [example-spring-loyalty](https://github.com/raksit31667/example-spring-loyalty)
powered by AWS Cloudformation.

## Prerequisites

- [AWS CloudFormation Linter](https://github.com/aws-cloudformation/cfn-lint)

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