# Well-lit Path: Intel XPU Inference

## Overview

This example demonstrates how to deploy models using Intel Data Center GPU Max (XPU) with the llm-d inference stack. This path has been designed for Intel XPU hardware and includes optimizations specific to Intel's GPU architecture.

> **Note**: This example requires Intel Data Center GPU Max hardware and appropriate Intel GPU drivers and runtime components.

## Prerequisites

### Hardware Requirements
- Intel Data Center GPU Max (Ponte Vecchio) series
- Sufficient system memory (32GB+ recommended)
- Intel Xeon processors (4th gen or newer recommended)

### Software Requirements
- Kubernetes 1.29+
- Intel GPU Device Plugin installed
- Intel GPU drivers (version 1.3.26918+)
- Intel oneAPI runtime (optional but recommended)

### Node Setup

Ensure your Kubernetes nodes have the following labels for XPU identification:

```bash
kubectl label nodes <node-name> accelerator=intel-xpu
kubectl label nodes <node-name> intel.com/gpu=present
```

## Installation

1. Set your namespace:

   ```bash
   export NAMESPACE=llm-d-xpu
   kubectl create namespace ${NAMESPACE}
   ```

2. Install the infrastructure:

   ```bash
   # Install llm-d-infra with XPU support
   helm install infra-xpu ../../charts/llm-d-infra \
     --namespace ${NAMESPACE} \
     --set provider.name=kubernetes \
     --set gateway.service.type=LoadBalancer
   ```

3. Deploy the model service:

   ```bash
   cd examples/intel-xpu
   helmfile --namespace ${NAMESPACE} apply
   ```

## Verifying the Installation

1. Check that pods are running:

   ```bash
   kubectl get pods -n ${NAMESPACE}
   ```

   You should see pods in Running state, including decode pods with XPU resources allocated.

2. Get the gateway endpoint:

   ```bash
   GATEWAY_NAME=infra-xpu-inference-gateway
   IP=$(kubectl get gateway/${GATEWAY_NAME} -n ${NAMESPACE} -o jsonpath='{.status.addresses[0].value}')
   PORT=80
   ```

3. Test the deployment:

   ```bash
   curl -s http://${IP}:${PORT}/v1/models | jq
   ```

4. Test inference:

   ```bash
   curl -s http://${IP}:${PORT}/v1/completions \
     -H "Content-Type: application/json" \
     -d '{
       "model": "microsoft/DialoGPT-medium",
       "prompt": "Hello, how are you?",
       "max_tokens": 50
     }' | jq
   ```

## Customization

- **Change model**: Edit `values.yaml` and update the `modelArtifacts.uri`
- **Adjust XPU resources**: Modify the GPU/memory requests in `values.yaml`
- **Scale workers**: Change the `replicas` count for decode deployments
- **XPU-specific tuning**: Adjust Intel GPU environment variables in the configuration

## Cleanup

```bash
helmfile --namespace ${NAMESPACE} destroy
helm uninstall infra-xpu -n ${NAMESPACE}
kubectl delete namespace ${NAMESPACE}
```

## Troubleshooting

### Common Issues

1. **XPU not detected**: Ensure Intel GPU device plugin is installed and nodes are properly labeled
2. **Driver issues**: Verify Intel GPU drivers are installed and compatible
3. **Memory allocation**: XPU models may require more system memory than GPU equivalents

### Debugging Commands

```bash
# Check XPU resource availability
kubectl describe nodes | grep intel.com/gpu

# Check Intel GPU device plugin
kubectl get pods -n kube-system | grep intel-gpu

# View XPU-specific logs
kubectl logs -l llm-d.ai/role=decode -n ${NAMESPACE}
```

## Performance Notes

- Intel XPU performance characteristics differ from NVIDIA GPUs
- Memory bandwidth and compute patterns may require model-specific tuning
- Consider using Intel-optimized model formats when available
- Monitor XPU utilization using Intel GPU monitoring tools
