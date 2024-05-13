#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(readlink -f $(dirname "$0"))"

TEMP=$(mktemp -d)
function finish {
  rm -rf $TEMP
}
trap finish EXIT

cd $TEMP

git clone --depth=1 https://github.com/grafana/grafana-zabbix
cd grafana-zabbix/

yarn install
npx --yes ts-json-schema-generator -p ./src/datasource/types/query.ts --tsconfig ./tsconfig.json -t ZabbixMetricsQuery -o ${ROOT_DIR}/generator/schema.json
