# P/D Disaggregation "Well Lit" Path

## Overview 

- This example demonstrates how to deploy vLLM with P/D disaggregation using Llama-70B with example best practics.
- This "path" has been validated on an 8xH200 cluster with infiniband networking.

> WARNING: We are still investigating and optimizing performance for other hardware and networing clusters.

In this example, we will demonstrate a deplyment of `Llama-3.3-70B-Instruct-Fp8` with:
- 4 TP=1 Prefill Workers
- 1 TP=4 Decode Worker

## P/D Best Practices

P/D disaggregation can benefit overall throughput by:
- Specializing P and D workers for compute-bound vs latency-bound tasks
- Reducing the number of copies of the model in the cluster for decode (increasing KV cache RAM)

However, P/D disaggregation is not a target for all workloads. We suggest exploring P/D disaggregation for:
- Large models (e.g. Llama-70B+, not Llama-8B)
- Longer input sequence lengths (e.g 10k ISL | 1k OSL, not 200 ISL | 200 OSL)
- Large MoE models with opportunities for wide-EP

As a result, as you tune you P/D deployments, we suggest tuning the following parameters: 
- **Heterogenous Parallelism**: deploy P workers with less parallelism and more replicas and D workers with more parallelism and fewer replicas
- **xPyD Ratios**: tuning the ratio of P workers to D workers to ensure balance for your ISL|OSL ratio

## Installation

1. Install your local dependencies (from `/llm-d-infra/quickstart`)

```bash
./install-deps.sh
```

2. Use the quickstart to deploy Gateway CRDS + Gateway provider + Infra chart (from `/llm-d-infra/quickstart`):
```bash
export HF_TOKEN=$(YOUR_TOKEN)
./llmd-infra-installer.sh --namespace llm-d -r infra-pd -j kgateway --disable-metrics-collection
```

3. Use the helmfile to apply the modelservice and GIE charts on top of it
```bash
helmfile --selector managedBy=helmfile apply helmfile.yaml
```

```bash
kubectl get pods


```

