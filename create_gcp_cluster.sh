#!/bin/bash

# Set up the cluster

# list the existing clusters
gcloud container clusters list | grep flask-vue-kubernetes

# Create cluster

result=$?
echo 'Return code (gcloud container clusters list):' $result

if [ $result -ne 0 ] 
then
    echo "Creating the cluster"
    # Perhaps increase nodes to 3?
    gcloud container clusters create flask-vue-kubernetes --num-nodes 1 --machine-type n1-standard-1
else
    echo "The cluster already exists"
fi
