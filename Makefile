.PHONY: build

build:
	@docker build -t spark-base-hadoop:2.4.6 ./docker/spark-base
	@docker build -t spark-master-hadoop:2.4.6 ./docker/spark-master
	@docker build -t spark-worker-hadoop:2.4.6 ./docker/spark-worker