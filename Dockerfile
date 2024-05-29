FROM google/cloud-sdk:455.0.0-alpine
LABEL com.bmeme.project.family='GKE-Helm Deployer Image' \
  com.bmeme.project.version='455.0.0-3.14.2' \
  com.bmeme.maintainer.1='Daniele Piaggesi <daniele.piaggesi@bmeme.com>' \
  com.bmeme.maintainer.2='Roberto Mariani <roberto.mariani@bmeme.com>' \
  com.bmeme.refreshedat='2024-05-29'

ENV HELM_VERSION v3.13.2

COPY scripts/common.sh /root/common.sh
COPY scripts/authenticate.sh /usr/bin/authenticate
COPY scripts/deploy.sh /usr/bin/deploy

RUN set -eux; \
  chmod u+x /usr/bin/authenticate; \
  chmod u+x /usr/bin/deploy; \
  \
  # Installing Helm 3
  curl -o /tmp/helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  tar -zxvf /tmp/helm.tar.gz -C /tmp; \
  mv /tmp/linux-amd64/helm /usr/bin/helm; \
  rm -rf /tmp/helm.tar.gz /tmp/linux-amd64; \
  \
  # Enable kubectl
  gcloud components install kubectl; \
  \
  # Remove backups
  rm -rf /google-cloud-sdk/.install/.backup; \
  rm -f /google-cloud-sdk/bin/kubectl.*
