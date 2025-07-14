# quickstart for facebook-opt-125m

## Installation

1. Install the dependencies
2. Use the quickstart to deploy Gateway CRDS + Gateway provider + Infra chart:
```bash
HF_TOKEN=$(HFTOKEN) ./llmd-infra-installer.sh --namespace llm-d -r infra-facebook
```
    - It should be noted release name `infra-facebook` is important here, because it matches up with pre-built values files used in this example.

3. Use the helmfile to apply the modelservice and GIE charts ontop of it
```bash
helmfile --selector managedBy=helmfile apply helmfile.yaml
```

With this all of your charts should be installed.

## Verify the Installation

1. Firstly you should be able to list all helm releases to view all 5 charts that should be installed:
```bash
helm list --all-namespaces --all --debug
NAME          	NAMESPACE      	REVISION	UPDATED                             	STATUS  	CHART                    	APP VERSION
gaie-facebook 	llm-d          	1       	2025-07-14 10:57:25.515174 -0700 PDT	deployed	inferencepool-v0         	v0
infra-facebook	llm-d          	1       	2025-07-14 10:46:56.074433 -0700 PDT	deployed	llm-d-infra-1.0.1        	0.1
kgateway      	kgateway-system	1       	2025-07-14 10:46:43.577928 -0700 PDT	deployed	kgateway-v2.0.3          	1.16.0
kgateway-crds 	kgateway-system	1       	2025-07-14 10:46:39.26078 -0700  PDT 	deployed	kgateway-crds-v2.0.3     	1.16.0
ms-facebook   	llm-d          	1       	2025-07-14 10:57:25.726526 -0700 PDT	deployed	llm-d-modelservice-0.0.10	0.0.1
```
Note: if you chose to use `istio` as your Gateway provider you would see those (`istiod` and `istio-base` in the `istio-system` namespace) instead of the kgateway based ones.

2. Find the gateway service:
```bash
kubectl get services
NAME                               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
gaie-facebook-epp                  ClusterIP   172.30.248.208   <none>        9002/TCP,9090/TCP   7m11s
infra-facebook-inference-gateway   NodePort    172.30.112.221   <none>        80:31790/TCP        17m
```
In this case we have found that our gateway service is called `infra-facebook-inference-gateway`.

3. `port-forward` the service to we can curl it:
```bash
kubectl port-forward service/infra-facebook-inference-gateway 8000:80
```

4. Try curling the `/v1/models` endpoint:
```bash
curl http://localhost:8000/v1/models \
  -H "Content-Type: application/json" | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   484    0   484    0     0   1903      0 --:--:-- --:--:-- --:--:--  1905
{
  "data": [
    {
      "created": 1752516744,
      "id": "facebook/opt-125m",
      "max_model_len": 2048,
      "object": "model",
      "owned_by": "vllm",
      "parent": null,
      "permission": [
        {
          "allow_create_engine": false,
          "allow_fine_tuning": false,
          "allow_logprobs": true,
          "allow_sampling": true,
          "allow_search_indices": false,
          "allow_view": true,
          "created": 1752516744,
          "group": null,
          "id": "modelperm-d702cfd969b04aa8830ec448960d5e98",
          "is_blocking": false,
          "object": "model_permission",
          "organization": "*"
        }
      ],
      "root": "facebook/opt-125m"
    }
  ],
  "object": "list"
}
```

5. Try curling the `v1/completions` endpoint:
```bash
curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "prompt": "How are you today?",
    "max_tokens": 50
  }' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   662    0   566  100    96   1088    184 --:--:-- --:--:-- --:--:--  1273
{
  "choices": [
    {
      "finish_reason": "length",
      "index": 0,
      "logprobs": null,
      "prompt_logprobs": null,
      "stop_reason": null,
      "text": "\nNot a bad day, thought I might cry in here if I stopped... Settled right in there with my stomach full of ache :(\nIt's normal to feel slightly better, just keep it up and you'll be fine :)\nthanks"
    }
  ],
  "created": 1752516865,
  "id": "cmpl-d960ff24-1a65-4614-a986-0ce87d1a83ea",
  "kv_transfer_params": null,
  "model": "facebook/opt-125m",
  "object": "text_completion",
  "usage": {
    "completion_tokens": 50,
    "prompt_tokens": 6,
    "prompt_tokens_details": null,
    "total_tokens": 56
  }
}
```
