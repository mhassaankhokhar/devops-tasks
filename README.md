# nexaquanta

```mermaid
flowchart TB
  subgraph Global
    DNS[Route 53 Geo DNS]
    CF[CloudFront(Global or Regional Distros)]
  end

  DNS --> CF

  %% AWS Region (US)
  subgraph AWS-US[US Region (AWS)]
    S3[S3 - SPA & Media]
    ECS_US[ECS/K8s (PHP API + Microservices)]
    RDS[RDS (Postgres/MySQL)]
    CH_US[ClickHouse Cluster]
  end

  %% OCI Region (KSA)
  subgraph OCI-KSA[KSA Region (Oracle Cloud)]
    OCI_OS[OCI Object Storage - Media/Uploads]
    K8S_KSA[K8s on OCI (PHP API + Microservices)]
    ADB[Autonomous DB / HeatWave]
    CH_KSA[ClickHouse Cluster]
  end

  %% Global traffic
  CF -->|/assets,/video| S3
  CF -->|/api (US)| ECS_US
  CF -->|/api (KSA)| K8S_KSA
  CF -->|KSA media| OCI_OS

  %% Backend connections
  ECS_US --> RDS
  ECS_US --> CH_US
  K8S_KSA --> ADB
  K8S_KSA --> CH_KSA
```
