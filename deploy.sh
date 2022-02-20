#!/bin/bash

# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euxo pipefail

directories="$(ls -1d ./*/)"

for directory in $directories
do
  directory_name="$(basename $directory)"

  if [[ $directory_name == 'eks-raksit31667' ]]; then
    continue
  fi
  
  aws cloudformation deploy \
  --stack-name $directory_name \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file "$directory_name/template.yml" \
  --no-fail-on-empty-changeset
done

# Uncomment to deploy EKS stacks
# Ref: https://s3.amazonaws.com/aws-quickstart/quickstart-amazon-eks/templates/amazon-eks-entrypoint-new-vpc.template.yaml

#aws cloudformation deploy \
#--stack-name "eks-raksit31667" \
#--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
#--template-file "eks-raksit31667/template.yml" \
#--parameter-overrides \
#AvailabilityZones="ap-southeast-1a,ap-southeast-1b,ap-southeast-1c" \
#RemoteAccessCIDR="119.76.14.135/32" KeyPairName="eks-raksit31667" EKSClusterName="raksit31667" \
#AdditionalEKSAdminUserArn="arn:aws:iam::564702493239:user/example-spring-loyalty" \
#EKSPublicAccessEndpoint="Enabled" \
#--no-fail-on-empty-changeset
#
#aws cloudformation deploy \
#--stack-name "vpc-peering-eks-rds" \
#--capabilities CAPABILITY_NAMED_IAM \
#--template-file "vpc-peering-eks-rds/template.yml" \
#--no-fail-on-empty-changeset
#
#aws cloudformation deploy \
#--stack-name "iam-role-eks-service-account" \
#--capabilities CAPABILITY_NAMED_IAM \
#--template-file "iam-role-eks-service-account/template.yml" \
#--no-fail-on-empty-changeset