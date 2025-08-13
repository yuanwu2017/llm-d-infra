# Quickstart with llm-d

## Our Well-Lit Paths

Our well-lit paths provide tested and benchmarked recipes and Helm charts to start serving quickly with best practices common to production deployments. They are extensible and customizable for particulars of your models and use cases, using popular open source components like Kubernetes, Envoy proxy, NIXL, and vLLM. Our intent is to eliminate the heavy lifting common in deploying inference at scale so users can focus on building.

We currently offer three tested and benchmarked paths to help deploying large models:

1. [Intelligent Inference Scheduling](./inference-scheduling) - Deploy [vLLM](https://docs.vllm.ai) behind the [Inference Gateway (IGW)](https://github.com/kubernetes-sigs/gateway-api-inference-extension) to decrease latency and increase throughput via [precise prefix-cache aware routing](https://github.com/llm-d-incubation/llm-d-infra/tree/main/quickstart/examples/precise-prefix-cache-aware) and [customizable scheduling policies](https://github.com/llm-d/llm-d-inference-scheduler/blob/main/docs/architecture.md).
2. [Prefill/Decode Disaggregation](./pd-disaggregation) - Reduce time to first token (TTFT) and get more predictable time per output token (TPOT) by splitting inference into prefill servers handling prompts and decode servers handling responses, primarily on large models such as Llama-70B and when processing very long prompts.
3. [Wide Expert-Parallelism](./wide-ep-lws) - Deploy very large Mixture-of-Experts (MoE) models like [DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1) and significantly reduce end-to-end latency and increase throughput by scaling up with [Data Parallelism and Expert Parallelism](https://docs.vllm.ai/en/latest/serving/data_parallel_deployment.html) over fast accelerator networks.
4. [Intel XPU Inference](./intel-xpu) - Deploy models on Intel Data Center GPU Max (XPU) hardware with optimizations specific to Intel's GPU architecture.

## Supporting Examples

- [llm-d Simulation](./sim) can deploy a vLLM model server simulator that allows testing inference scheduling at scale as each instance does not need accelerators.

### Hardware-Specific Examples
- **[Intel XPU](./intel-xpu)** - For Intel Data Center GPU Max deployments
