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

  echo "Deploying $directory_name stack..."
  
  aws cloudformation deploy \
  --stack-name $directory_name \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file "$directory_name/template.yml" \
  --no-fail-on-empty-changeset
done

rds_instance_identifier="example-spring-loyalty-db"

rds_password="$(aws secretsmanager get-secret-value --secret-id ExampleSpringLoyaltyPostgreSQLSecret --query
SecretString --output text | jq -r '.DB_PASSWORD')"

rds_host="$(aws rds describe-db-instances --db-instance-identifier $rds_instance_identifier | jq -r '.DBInstances[0]
.Endpoint.Address')"

function run_psql_command() {
  local command=$1

  # https://github.com/jbergknoff/Dockerfile/tree/master/postgresql-client
  docker run --env PGPASSWORD="$rds_password" -it --rm jbergknoff/postgresql-client \
    --host="$rds_host" \
    --port=5432 \
    --dbname=ExampleSpringLoyalty \
    -c "$command"
}

echo "Create RDS PostgreSQL role for pgaudit"
run_psql_command "DO \$\$
  BEGIN
  CREATE ROLE rds_pgaudit;
  EXCEPTION WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
  END
  \$\$;"

echo "Rebooting RDS instance"
aws rds reboot-db-instance --db-instance-identifier $rds_instance_identifier > /dev/null 2>&1 &

echo "Waiting for RDS to become available"
aws rds wait db-instance-available --db-instance-identifier $rds_instance_identifier

echo "Creating pgaudit extension"
run_psql_command 'CREATE EXTENSION IF NOT EXISTS pgaudit CASCADE;'

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