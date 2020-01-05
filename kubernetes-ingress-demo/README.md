# Set up Ingress on GCP

This comes from a help page at [Configuring load balancing through Ingress](https://cloud.google.com/kubernetes-engine/docs/how-to/load-balance-ingress)

## Filter to find the IP address

```sh
kubectl get ingresses.extensions my-ingress -o json | jq -r '.status.loadBalancer.ingress[].ip'
```

Produces:

```text
34.98.84.115
```
