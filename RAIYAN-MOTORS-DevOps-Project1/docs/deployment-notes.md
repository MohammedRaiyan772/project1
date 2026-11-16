# Deployment notes

## Kubernetes objects

- `Deployment/raiyan-motors` manages two application replicas.
- Both Pods use label `app: motors`.
- `topologySpreadConstraints` asks the scheduler to keep matching Pods evenly spread by node hostname when possible. `ScheduleAnyway` is a preference, not a hard guarantee.
- `Service/motors-service` selects Pods with `app: motors` and exposes TCP port `30080` on each node.

## Useful commands

```bash
kubectl get nodes -o wide
kubectl get deployments
kubectl get pods -o wide
kubectl get services
kubectl describe deployment raiyan-motors
kubectl describe service motors-service
kubectl logs deployment/raiyan-motors
kubectl rollout status deployment/raiyan-motors
```

## Updating the website

1. Edit `website/index.html`.
2. Build a new image tag (for example `v2`).
3. Push the image to Docker Hub.
4. Update the image tag in `kubernetes/deployment.yml`.
5. Apply the manifest and verify the rollout.

```bash
docker build -t YOUR_DOCKERHUB_USERNAME/raiyan-motors:v2 -f docker/Dockerfile website
docker push YOUR_DOCKERHUB_USERNAME/raiyan-motors:v2
kubectl apply -f kubernetes/deployment.yml
kubectl rollout status deployment/raiyan-motors
```

## Important distinction

A Deployment creates and maintains Pods. A Service does not create or replicate Pods. NodePort exposes the Service on each node's IP and forwards traffic to ready matching Pods.
