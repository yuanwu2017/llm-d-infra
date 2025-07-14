kubectl apply -n ${NAMESPACE} -f benchmark-pod-interactive.yaml
kubectl cp Justfile.remote ${NAMESPACE}/benchmark-interactive:/app/Justfile
kubectl exec -it -n ${NAMESPACE} benchmark-interactive -- /bin/bash
