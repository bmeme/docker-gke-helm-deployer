[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

GKE HELM DEPLOYER
=====

Google Cloud SDK docker image, based on the official [google/cloud-sdk](https://hub.docker.com/r/google/cloud-sdk) and integrated with [Helm](https://helm.sh/), currently being used in Bmeme for Continuous Deployment.

## What is contained in the images
* Google Cloud SDK (gcloud)
* Kubectl component enabled
* Helm
* A script `authenticate` that wraps authentication tasks against Google Cloud
* A script `deploy` that wraps `helm update` task

## Mandatory environments
| Variable Name | Description |
|---------------|-------------|
|`GCP_SERVICE_ACCOUNT`| The json key of the Google Service Account granted|
|`GCP_PROJECT_ID`| Your Google Cloud project ID |
|`GKE_CLUSTER`| The name of the GKE cluster on which to install the application via Helm. |
|`GKE_ZONE`| The zone of the GKE cluster |

## Scripts

### Authentication
Set mandatory enviroments, then:

```
# /usr/bin/authenticate
```

### Deploy

```
# /usr/bin/deploy -h

This script facilitates Helm deployment on a Kubernetes cluster.

SYNOPSIS
deploy [-dh] [-a release_name] [-n namespace] [-c chart] [-v chart_version] [-f file]

-a release_name
  Specify the release name. Mandatory.

-n namespace
  Specify the namespace where to install. Mandatory

-c chart_name
  Specify the chart name to install. Mandatory

-v chart_version
  Specific version to install. Optional

-f file
  The absolute/relative path of the values file. Optional

-d
  Execute the helm command with --debug --dryrun

-h
  Display this help
```


## How to use it in a `.gitlab-ci.yml` pipeline
```
image: bmeme/gke-helm-deployer:latest

stages:
  - dry_run
  - deploy

variables:
  GCP_PROJECT_ID: my-gcp-project
  GKE_CLUSTER: my-awesome-cluster
  GKE_ZONE: europe-west3-b

before_script:
  - /usr/bin/authenticate
  - helm repo add my-repo https://my-chart-repo.example.com
  - helm repo update

dry_run:
  stage: dry_run
  script:
    - |
      /usr/bin/deploy \
        -a my-app \
        -n my-namespace \
        -c my-repo/my-chart \
        -v 1.0.0 \
        -f ./values.yaml \
        -d

deploy:
  stage: deploy
  script:
    - |
      /usr/bin/deploy \
        -a my-app \
        -n my-namespace \
        -c my-repo/my-chart \
        -v 1.0.0 \
        -f ./values.yaml
    - kubectl rollout status deployment/my-app -n my-namespace
```
