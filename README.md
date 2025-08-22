# nexaquanta

```
sequenceDiagram
participant U as Uploader (KSA/US)
participant CF as CloudFront (Global or Separate Distributions)
participant OS as Object Storage (S3/OCI)
participant Q as Event Bus / Queue (SQS/OCI Streaming)
participant W as Transcoder Workers (K8s/ECS)
participant P as Packager (HLS/DASH)
participant OR as Renditions Bucket (S3/OCI)
U->>CF: Upload via pre‑signed URL (chunked)
CF->>OS: PUT chunks → assemble
OS-->>Q: ObjectCreated event
Q-->>W: Job message (with policy + region)
W->>P: Transcode multi‑bitrate (H.264/AV1)
P->>OR: PUT segments + manifests
CF-->>U: Playback via signed URLs/headers (routed to correct origin by region)
```
