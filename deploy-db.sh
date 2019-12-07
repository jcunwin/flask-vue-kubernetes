#!/bin/bash

POD_NAME=$(kubectl get pod -l service=postgres -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME --stdin --tty -- psql -U sample -c "drop database if exists books"
kubectl exec $POD_NAME --stdin --tty -- createdb -U sample books

FLASK_POD_NAME=$(kubectl get pod -l app=flask -o jsonpath="{.items[0].metadata.name}")
kubectl exec $FLASK_POD_NAME --stdin --tty -- python manage.py recreate_db
kubectl exec $FLASK_POD_NAME --stdin --tty -- python manage.py seed_db

# kubectl exec $POD_NAME --stdin --tty -- psql -U sample -c "connect books; select * from books"

curl http://hello.world/books