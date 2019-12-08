#!/bin/bash

# Delete the cluster

# list the existing clusters
gcloud container clusters list | grep flask-vue-kubernetes

# Delete cluster
result=$?
echo 'Return code (gcloud container clusters list):' $result

if [ $result -eq 0 ] 
then
    # "Deleting the cluster"
    gcloud container clusters delete flask-vue-kubernetes --quiet
else
    echo "The cluster doesn't exist"
fi
