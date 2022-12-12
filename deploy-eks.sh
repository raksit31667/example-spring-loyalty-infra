#!/bin/bash

# Ref: https://blog.knoldus.com/aws-eks-cluster-by-cloudformation/

aws cloudformation deploy \
--stack-name "eks-raksit31667" \
--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
--template-file "eks-raksit31667/template.yml" \
--no-fail-on-empty-changeset
