These are open showcases, that doesn't worked properly yet...



## Distributed Tracing with Jaeger
See tutorial from Linkerd: https://linkerd.io/2/tasks/distributed-tracing/

Activate tracing:
Generate a yaml (here `tracing.yaml`) file with the following two lines:
```
tracing:
  enabled: true
```
and apply it to Linkerd:
```
linkerd upgrade --config tracing.yaml | kubectl -n <namespace> apply -f -
```
This will install OpenCensus collector and Jaeger backend.

Set environment for namespace you'd like to trace:
```
kubectl -n <namespace> set env --all deploy OC_AGENT_HOST=linkerd-collector.linkerd:55678
```

Next to Grafana-symbol next to each service in the Linkerd dashboard, you'll now find a Jaeger-symbol for distributed tracing.
