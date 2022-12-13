#!/bin/bash

# Ref: https://blog.knoldus.com/aws-eks-cluster-by-cloudformation/

aws cloudformation deploy \
--stack-name "eks-raksit31667" \
--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
--template-file "eks/eks-raksit31667/template.yml" \
--no-fail-on-empty-changeset

aws cloudformation deploy \
--stack-name "iam-role-eks-service-account" \
--capabilities CAPABILITY_NAMED_IAM \
--template-file "eks/iam-role-eks-service-account/template.yml" \
--no-fail-on-empty-changeset

#aws cloudformation deploy \
#--stack-name "vpc-peering-eks-rds" \
#--capabilities CAPABILITY_NAMED_IAM \
#--template-file "eks/vpc-peering-eks-rds/template.yml" \
#--no-fail-on-empty-changeset
