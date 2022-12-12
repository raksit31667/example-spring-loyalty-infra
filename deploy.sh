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
