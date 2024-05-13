ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: generator/schema.json zabbix-query-libsonnet/main.libsonnet zabbix-query-libsonnet/docs/

all: generator/schema.json zabbix-query-libsonnet/main.libsonnet zabbix-query-libsonnet/docs/

generator/schema.json:
	sh ./generate_schema.sh

zabbix-query-libsonnet/main.libsonnet:
	jsonnet -J generator/vendor -S $(ROOT_DIR)/generator/main.libsonnet \
		| jsonnetfmt --no-use-implicit-plus - > $(ROOT_DIR)/zabbix-query-libsonnet/main.libsonnet

zabbix-query-libsonnet/docs/:
	@rm -rf zabbix-query-libsonnet/docs/ && \
	jsonnet -J generator/vendor -S -c -m zabbix-query-libsonnet/docs/ \
			--exec "(import 'doc-util/main.libsonnet').render(import 'zabbix-query-libsonnet/main.libsonnet')"
