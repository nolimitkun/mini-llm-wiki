---
title: Model serving
category: ml-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Model serving

**Model serving** is how a trained model's predictions reach consumers — as a nightly batch of scores, a low-latency API, or a stream processor. The serving pattern, not the model, determines most of the engineering cost; choose the *least* online pattern that meets the product need.

## The three patterns

| Pattern | How | Latency | Cost/ops | Fit |
|---|---|---|---|---|
| **Batch scoring** | [Orchestrated job](orchestration.md) scores a table; results land in the [warehouse](data-warehouse.md)/cache | Hours | Lowest — it's a pipeline | Churn scores, recommendations refreshed daily, most use cases honestly |
| **Online serving** | Model behind an API; features fetched at request time ([feature store](feature-stores.md)) | ms | Highest — a 24/7 service with SLOs | Fraud checks, ranking, dynamic pricing |
| **Streaming scoring** | Model embedded in a [stream processor](stream-processing.md) | Seconds | Medium | Event-driven decisions, alerting |

The classic error is defaulting to online serving for predictions consumed once a day — paying service-ownership costs for pipeline value.

## Online serving engineering

- **Feature access dominates latency**: request-time lookups from the online [feature store](feature-stores.md); precompute what you can.
- **Deployment safety**: model versions promoted through a registry with [eval gates](mlops.md); shadow deployments (score, don't act), canary %, instant rollback.
- **Observability**: log inputs + outputs (governed — they're data: [data-governance.md](data-governance.md)) for drift detection and retraining sets.
- **Scaling shape**: CPU inference for most classic ML; GPUs enter with deep models — then batching and utilization economics start to matter.

## LLM serving: same discipline, harsher physics

Serving LLMs inherits everything above plus its own regime — huge models, token-by-token generation, GPU memory as the binding constraint:

- **Two-phase requests**: prompt *prefill* (parallel, compute-bound) then *decode* (sequential, memory-bandwidth-bound) — so time-to-first-token and tokens/sec are separate SLOs.
- **Continuous batching + KV-cache management** (vLLM/SGLang-class engines) determine throughput; **quantization** (FP8/INT4) trades memory for evaluated quality loss.
- **Most teams consume provider APIs** rather than self-hosting — making the serving problem one of gateways, quotas, caching, and failover instead of GPUs ([llms-on-the-platform.md](llms-on-the-platform.md), [build-vs-buy.md](build-vs-buy.md)).
- Cost scales with *tokens processed*, not instances — a different [FinOps](finops.md) conversation.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **KServe** | Kubernetes-native model inference with canary, autoscaling, multi-framework serving | Good platform primitive; Kubernetes complexity comes with it |
| **Seldon Core** | Advanced inference graphs, explainers, Kubernetes ML serving patterns | Powerful but another control plane to operate |
| **BentoML** | Packaging models as services with developer-friendly APIs | Great app packaging; platform governance/registry/traffic policy need integration |
| **MLflow Deployments/Models** | Teams already using MLflow registry and tracking | Convenient default; less specialized than KServe/Seldon for large multi-tenant serving |
| **Ray Serve** | Python-native scalable serving, ensembles, model composition | Strong when Ray is already the compute substrate |
| **vLLM / SGLang / TGI** | LLM-specific high-throughput GPU serving | Specialized for generative models; still need gateway, evals, quotas, and logging |

Choose classic serving by deployment topology, and LLM serving by throughput, GPU memory, batching behavior, and operational visibility.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **SageMaker endpoints** | AWS-native model deployment, autoscaling, monitoring, and registry integration | Broad but configurable; cost and endpoint sprawl need governance |
| **Vertex AI Prediction** | GCP-native managed online/batch prediction | Best with Vertex AI pipelines/registry; custom serving still requires care |
| **Azure ML managed endpoints** | Azure-native managed inference integrated with Microsoft identity and ML lifecycle | Strong Azure fit; product boundaries with AI Foundry should be understood |
| **Databricks Model Serving / Mosaic AI Gateway** | Lakehouse-native classic ML and GenAI serving with governance close to data | Best inside Databricks; evaluate latency/cost for high-QPS serving |
| **BentoCloud / Baseten / Modal / Replicate** | Developer-friendly model serving and GPU-backed deployment for startups/product teams | Great speed; governance and data residency must be checked |
| **OpenAI / Anthropic / Google / Azure model APIs** | Foundation model serving without owning GPUs | Gateway, evals, data policy, and provider risk become the platform work |

Commercial serving choice is about operational burden: managed endpoints for classic ML, provider APIs for most LLMs, self-host only when control or economics wins.

## Related

- [ml-platform-overview.md](ml-platform-overview.md)
- [feature-stores.md](feature-stores.md)
- [llms-on-the-platform.md](llms-on-the-platform.md)
