CONFIG_PATH=${HOME}/.proglog/

.PHONY: init
init:
	mkdir -p ${CONFIG_PATH}

.PHONY: getcert
gencert:
	cfssl gencert -initca test/ca-csr.json | cfssljson -bare ca

	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=server \
		test/server-csr.json | cfssljson -bare server
		
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="root" \
		test/client-csr.json | cfssljson -bare root-client


	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="nobody" \
		test/client-csr.json | cfssljson -bare nobody-client

	mv *.pem *.csr ${CONFIG_PATH}

$(CONFIG_PATH)/model.conf:
	rm -f $(CONFIG_PATH)/model.csv
	cp test/model.conf $(CONFIG_PATH)/model.conf

$(CONFIG_PATH)/policy.csv:
	rm -f $(CONFIG_PATH)/policy.csv
	cp test/policy.csv $(CONFIG_PATH)/policy.csv

.PHONY: test
test: $(CONFIG_PATH)/model.conf $(CONFIG_PATH)/policy.csv
	go test -race ./...

.PHONY: compile
compile:
	protoc api/v1/*.proto \
	--go_out=. \
	--go-grpc_out=. \
	--go-grpc_opt=paths=source_relative \
	--go_opt=paths=source_relative \
	--proto_path=.

# START: build_docker
TAG ?= 0.0.1

build-docker:
	docker build -t github.com/grebeniuk/proglog:$(TAG) .

# END: build_docker
