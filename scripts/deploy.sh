#!/bin/bash

source /root/common.sh

APP_NAME=$1
KUBE_NAMESPACE=$2

help() {
  echo "This script provides helm deploy against a Kubernetes cluster."
  echo ""
  echo "SYNOPSIS"
  echo "deploy [-dh] [-a release] [-n namespace] [-c chart] [-v chart version] [-f file]"
  echo ""
  echo "-a release_name"
  echo "  Specify the release name. Mandatory."
  echo ""
  echo "-n namespace"
  echo "  Specify the namespace where to install. Mandatory"
  echo ""
  echo "-c chart_name"
  echo "  Specify the chart name to install. Mandatory"
  echo ""
  echo "-v chart_version"
  echo "  Specific version to install. Optional"
  echo ""
  echo "-f file"
  echo "  The absolute/relative path of the values file. Optional"
  echo ""
  echo "-d"
  echo "  Execute the helm command with --debug --dryrun"
  echo ""
  echo "-h"
  echo "  Prints this help"
}

while getopts a:n:c:v:df:h flag
do
    case "${flag}" in
        a) APP_NAME=${OPTARG};;
        n) KUBE_NAMESPACE=${OPTARG};;
        c) CHART=${OPTARG};;
        v) CHART_VERSION=${OPTARG};;
        d) DEBUG="--dry-run --debug";;
        f) FILE=${OPTARG};;
        h) HELP=TRUE;;
    esac
done

if [[ ${HELP} ]]; then
  help
  exit
fi

if [[ -z "${APP_NAME}" ]]; then
  empty_variable APP_NAME
fi

if [[ -z "${KUBE_NAMESPACE}" ]]; then
  empty_variable KUBE_NAMESPACE
fi

if [[ -z "${CHART}" ]]; then
  empty_variable CHART
fi

if [[ ${error_code} != 0 ]]; then
  exit ${error_code}
fi

CMD="/usr/bin/helm upgrade ${APP_NAME} --install \
    --namespace ${KUBE_NAMESPACE} --create-namespace"

[[ "${DEBUG}" ]] && CMD="${CMD} ${DEBUG}"

CMD="${CMD} ${CHART}"

[[ "${FILE}" ]] && CMD="-f ${FILE}

[[ "${CHART_VERSION}" ]] && CMD="${CMD} --version ${CHART_VERSION}"

${CMD}
