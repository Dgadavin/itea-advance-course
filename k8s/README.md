# Usefull kubectl commands

## Working with nodes
```bash
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>

kubectl drain <node-name>
kubectl uncordon <node-name>
```
## Working with pods
```bash
kubectl get pod
kubectl get pod -A
kubectl get pods -l app=nginx
kubectl get all

kubectl create --name nginx --image=nginx

kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>

kubectl exec -it <pod-name> bash

kubectl get pod <pod-name> -o yaml
kubectl describe pod <pod-name>
kubectl edit pod <pod-name>
```
## Working with deployments
```bash
kubectl get deployments
kubectl describe deployments <deployment-name>
kubectl edit deployments <deployment-name>
```
### Perform a rolling update with deployments
```bash
kubectl apply -f deployment_nginx.yaml
kubectl get deployments
kubectl get rs
kubectl rollout status deployment/<deployment-name>
kubectl set image deployment/<deployment-name> nginx=nginx:1.16.1 --record
kubectl rollout history deployment/<deployment-name>
kubectl set image deployment/<deployment-name> nginx=nginx:1.17 --record
kubectl rollout undo deployment/<deployment-name>
kubectl scale deployment/<deployment-name> --replicas=2
```

## Working with services

```bash
```
