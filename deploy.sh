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
--stack-name "eks-raksit31667" \
--capabilities CAPABILITY_NAMED_IAM \
--template-file "eks-raksit31667/template.yml" \
--parameter-overrides "file://eks-raksit31667/parameters.yml" \
--no-fail-on-empty-changeset