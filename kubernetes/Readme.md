# Kubernetes

This project is deployed over Windmaker's Kubernetes cluster.

## Prerequisites

As cluster admin you should create project's namespace and specific service account to operate over this namespace.

```bash
kubectl apply -f setup.yaml
```

Gitlab CI/CD needs gitlab-mysql-test-runner token:
```
kubectl -n mysql-test describe secrets $(kubectl -n mysql-test get secret | grep gitlab-mysql-test-runner | awk  '{print $1}') | grep token: | awk  '{print $2}'
```

The following namespace will be created:

* mysql-test

Gitlab Runner has to be configured too:
```
/usr/local/bin/helm install gitlab-mysql-test-deployer  --namespace mysql-test -f values.yaml gitlab/gitlab-runner
```
