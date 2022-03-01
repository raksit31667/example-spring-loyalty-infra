#!/bin/bash

set -euxo pipefail

rds_instance_identifier="example-spring-loyalty-db"

rds_password="$(aws secretsmanager get-secret-value --secret-id ExampleSpringLoyaltyPostgreSQLSecret \
--query SecretString --output text | jq -r '.password')"

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