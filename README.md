```mermaid
flowchart TB
  subgraph Global
    DNS[Route 53 Geo DNS]
    CF[CloudFront - Global or Regional]
  end

  DNS --> CF

  %% AWS Region (US)
  subgraph AWS-US[US Region AWS]
    direction TB
    subgraph AWS-AZs[3 AZ Deployment]
      AZ1_US[AZ-1]
      AZ2_US[AZ-2]
      AZ3_US[AZ-3]
    end
    ECS_US[ECS or K8s - API Pods]
    RDS_US[RDS Multi-AZ Primary + Standby]
    CH_US[ClickHouse Cluster Shards + Replicas]
    S3_US[S3 - SPA and Media]
  end

  %% OCI Region (KSA)
  subgraph OCI-KSA[KSA Region Oracle Cloud]
    direction TB
    subgraph OCI-AZs[3 Fault Domains / AZs]
      AZ1_KSA[AZ-1]
      AZ2_KSA[AZ-2]
      AZ3_KSA[AZ-3]
    end
    K8S_KSA[K8s on OCI - API Pods]
    ADB[Autonomous DB - HA within KSA]
    CH_KSA[ClickHouse Cluster - Replicas across AZs]
    OCI_OS[OCI Object Storage - Media & Uploads]
  end

  %% Global routing
  CF -->|/assets or /video| S3_US
  CF -->|/api US| ECS_US
  CF -->|/api KSA| K8S_KSA
  CF -->|KSA media| OCI_OS

  %% US connections
  ECS_US --> RDS_US
  ECS_US --> CH_US

  %% KSA connections
  K8S_KSA --> ADB
  K8S_KSA --> CH_KSA

  %% Notes
  note right of RDS_US:: "Multi-AZ standby + automated failover"
  note right of ADB:: "HA inside OCI, backups stay in KSA"
  note bottom of CH_US:: "Shards replicated across AZs"
  note bottom of CH_KSA:: "Replicas across fault domains"
```
