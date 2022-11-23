SHELL := /bin/bash

run:
	go run main.go

# Set "build" variable to "local"
build:
	go build -ldflags "-X main.build=local"

# ==============================================================================
# Building containers

VERSION := 1.0

all: service

service:
	docker build \
		-f zarf/docker/dockerfile \
		-t dev.local/service-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

# ==============================================================================
# Kind cluster

KIND_CLUSTER := kubeflow

kind-up:
	kind create cluster \
		--image kindest/node:v1.25.3@sha256:f52781bc0d7a19fb6c405c2af83abfeb311f130707a0e219175677e366cc45d1 \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind-config.yaml
# kubectl config set-context --curent --namespace=sales-system

kind-load:
	kind load docker-image dev.local/service-amd64:${VERSION} --name ${KIND_CLUSTER}

kind-down:
	kind delete cluster --name ${KIND_CLUSTER}

kind-status:
	kubectl get nodes -o wide
	echo
	kubectl get svc -o wide
	echo
	kubectl get pods --watch -owide --service-system

km-apply:
	kustomize build zarf/k8s/ | kubectl apply -f -

kind-restart:
	kubectl -n service-system rollout restart deployment

kind-update: all kind-load km-apply kind-restart

logs:
	stern service -n service-system


# ==============================================================================
# Module support

tidy:
	go mod tidy
	go mod vendor
