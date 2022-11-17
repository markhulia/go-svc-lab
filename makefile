SHELL := /bin/bash

run:
	go run main.go

# Set "build" variable to "local"
build:
	go build -ldflags "-X main.build=local"
