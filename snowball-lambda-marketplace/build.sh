#!/bin/bash

#go mod init github.com/dan5179/snowball-lambda-marketplace

#go mod tidy

GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bootstrap main.go

zip myFunction.zip bootstrap
