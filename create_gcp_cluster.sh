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
    # Perhaps use bigger machines: f1-micro vs. n1-standard-1
    #    append the following option
    #         --machine-type f1-micro
    #         --machine-type n1-standard-1 # default size?
    #
    #gcloud container clusters create flask-vue-kubernetes --num-nodes 3
    #
    # --release-channel requires "beta" "rapid" uses kubernetes version 1.16.0-gke.20
    gcloud beta container clusters create flask-vue-kubernetes --num-nodes 3 --release-channel rapid --enable-ip-alias

else
    echo "The cluster already exists"
fi
