#!/bin/bash

source /root/common.sh

info "${GREEN} Validating variables ${RESET}"

if [[ -z "${GCP_SERVICE_ACCOUNT}" ]]; then
  empty_variable GCP_SERVICE_ACCOUNT
fi

if [[ -z "${GCP_PROJECT_ID}" ]]; then
  empty_variable GCP_PROJECT_ID
fi

if [[ -z "${GKE_CLUSTER}" ]]; then
  empty_variable GKE_CLUSTER
fi

if [[ -z "${GKE_ZONE}" ]]; then
  empty_variable GKE_ZONE
fi

if [[ ${error_code} != 0 ]]; then
  exit ${error_code}
fi

echo ${GCP_SERVICE_ACCOUNT} > /tmp/gcloud-service-key.json
gcloud auth activate-service-account --key-file /tmp/gcloud-service-key.json
gcloud container clusters get-credentials ${GKE_CLUSTER} \
  --zone ${GKE_ZONE} \
  --project ${GCP_PROJECT_ID}
