# Example Deployment P/D Disaggregation

## Installation

1. Install the dependencies

2. Use the quickstart to deploy Gateway CRDS + Gateway provider + Infra chart:
```bash
export HF_TOKEN=$(SET_YOUR_TOKEN)
./llmd-infra-installer.sh --namespace llm-d -r infra-pd -j kgateway --disable-metrics-collection
```

3. Use the helmfile to apply the modelservice and GIE charts ontop of it
```bash
helmfile --selector managedBy=helmfile apply helmfile.yaml
```
