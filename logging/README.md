# Logging

## Setup EFK stack

```bash
helm repo add elastic https://helm.elastic.co
helm install elasticsearch -f logging/es_values.yml elastic/elasticsearch
kubectl apply -f kibana.yml
helm repo add kiwigrid https://kiwigrid.github.io
helm install fluentd -f fluent_values.yml kiwigrid/fluentd-elasticsearch
```

To use kibana please do port-forward

```bash
kubectl port-forward <kibana-pod-name>  9000:5601
```


## Setup Prometheus stack

```bash
helm install prometheus stable/prometheus
helm install grafana stable/grafana
kubectl port-forward <grafana-pod-name>  3000:3000

```
