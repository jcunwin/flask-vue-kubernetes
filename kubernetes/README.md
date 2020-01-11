# Kubernetes deployments of the examples

## Ingress on Google Cloud Platform

The ingress that works for `minikube` doesn't work for GCP.

Problem:

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: gcp-ingress
spec:
  rules:
  - http:
      paths:
      - path: /books/*
        backend:
          serviceName: flask
          servicePort: 8080
```

With a path of `/books/*`, the straightforward url `books` doesn't work. Returns:

```text
response 404 (backend NotFound), service rules for [ /books ] non-existent
```

The `/books/ping` request _does_ work:

```json
{"container_id":"flask-78c7f84d5f-plk79","message":"pong!","status":"success"}
```

Alternatives with `/` and `/books/` don't fix it.

### Basic ingress

To get the flask application working and accessible I simplified the ingress.

The basic ingress works.

Changes include removing the paths and having the ingress map to just one service.

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: flask-basic-ingress
spec:
  backend:
    serviceName: flask
    servicePort: 8080
```

### Switch to using a `path` spec

Initially tried adding a path spec to the basic ingress above, It worked!



Why doesn't this work?

```shell
kubectl get ingresses.extensions gcp-ingress -o yaml
```

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/backends: '{"k8s-be-31284--99ed60b793492561":"Unknown","k8s-be-32286--99ed60b793492561":"Unknown"}'
    ingress.kubernetes.io/forwarding-rule: k8s-fw-default-gcp-ingress--99ed60b793492561
    ingress.kubernetes.io/target-proxy: k8s-tp-default-gcp-ingress--99ed60b793492561
    ingress.kubernetes.io/url-map: k8s-um-default-gcp-ingress--99ed60b793492561
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"networking.k8s.io/v1beta1","kind":"Ingress","metadata":{"annotations":{},"name":"gcp-ingress","namespace":"default"},"spec":{"rules":[{"http":{"paths":[{"backend":{"serviceName":"flask","servicePort":8080},"path":"/books/*"}]}}]}}
  creationTimestamp: "2020-01-05T01:55:44Z"
  finalizers:
  - networking.gke.io/ingress-finalizer
  generation: 1
  name: gcp-ingress
  namespace: default
  resourceVersion: "579006"
  selfLink: /apis/extensions/v1beta1/namespaces/default/ingresses/gcp-ingress
  uid: ee7d8e9d-0dea-45dd-8f1c-3894f0260f07
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: flask
          servicePort: 8080
        path: /books/*
status:
  loadBalancer:
    ingress:
    - ip: 34.95.64.68
```