FROM alpine/helm:3.16.1 as helm
FROM google/cloud-sdk:495.0.0-alpine
LABEL com.bmeme.project.family='GKE-Helm Deployer Image' \
  com.bmeme.project.version='495.0.0-3.16.1' \
  com.bmeme.maintainer.1='Daniele Piaggesi <daniele.piaggesi@bmeme.com>' \
  com.bmeme.maintainer.2='Roberto Mariani <roberto.mariani@bmeme.com>' \
  com.bmeme.refreshedat='2024-10-03'

## Adding Helm
COPY --from=helm /usr/bin/helm /usr/bin/helm

COPY scripts/common.sh /root/common.sh
COPY scripts/authenticate.sh /usr/bin/authenticate
COPY scripts/deploy.sh /usr/bin/deploy

RUN set -eux; \
  chmod u+x /usr/bin/authenticate; \
  chmod u+x /usr/bin/deploy; \
  \
  # Enable kubectl
  gcloud components install kubectl; \
  \
  # Remove backups
  rm -rf /google-cloud-sdk/.install/.backup; \
  rm -f /google-cloud-sdk/bin/kubectl.*
