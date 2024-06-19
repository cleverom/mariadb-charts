#!/bin/bash

set -e
set -o pipefail

# initializing slack orb variables
echo export GIT_COMMIT_ID=$( git log -1 --format=format:"%h" ) >> $BASH_ENV                 
echo export GIT_COMMIT_DESC=$( git log --oneline --format=%B -n 1 HEAD | head -n 1 | sed 's/^/"/;s/$/"/' ) >> $BASH_ENV  
echo export GIT_COMMIT_AUTHOR=$( git log -1 --pretty=format:'%an' ) >> $BASH_ENV   
echo export BACKTICK=\\\` >> $BASH_ENV             
source $BASH_ENV
namespace="default"

WORKING_DIRECTORY="$PWD"
CHARTNAME=$1

echo "Deploying service: ${CHARTNAME}"

echo "Using namespace: $namespace"

#using GCP as a case study here

echo "Authenticating with service account..."
echo $service_key > key.json
gcloud auth activate-service-account --key-file key.json

echo "Connecting to cluster: $cluster_name in zone: $cluster_zone"

gcloud container clusters get-credentials $cluster_name --zone $cluster_zone --project $project_id

echo "Adding Mariadb Helm Repo..."
helm repo add cleverom https://github.com/cleverom/db-charts.git
helm repo update

helm upgrade -i $CHARTNAME cleverom/$CHARTNAME --namespace $namespace  -f $valuesfile
   
#EOF
