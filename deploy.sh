#!/bin/bash

# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euxo pipefail

aws cloudformation deploy \
--stack-name "iam-role-example-spring-loyalty" \
--capabilities CAPABILITY_NAMED_IAM \
--template-file "iam-role-example-spring-loyalty/template.yml" \
--no-fail-on-empty-changeset

aws cloudformation deploy \
--stack-name "kinesis-data-stream-activity-performed" \
--capabilities CAPABILITY_NAMED_IAM \
--template-file "kinesis-data-stream-activity-performed/template.yml" \
--no-fail-on-empty-changeset

aws cloudformation deploy \
--stack-name "s3-java-gradle-cache" \
--capabilities CAPABILITY_NAMED_IAM \
--template-file "s3-java-gradle-cache/template.yml" \
--no-fail-on-empty-changeset

aws cloudformation deploy \
--stack-name "eks-raksit31667" \
--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
--template-file "eks-raksit31667/template.yml" \
--parameter-overrides \
AvailabilityZones="ap-southeast-1a,ap-southeast-1b,ap-southeast-1c" \
RemoteAccessCIDR="124.120.16.95/32" KeyPairName="eks-raksit31667" EKSClusterName="raksit31667" \
AdditionalEKSAdminUserArn="arn:aws:iam::564702493239:user/example-spring-loyalty" \
EKSPublicAccessEndpoint="Enabled" \
--no-fail-on-empty-changeset