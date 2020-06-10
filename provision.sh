#!/bin/env bash

set -eax

docker run --rm -it -v "$(pwd)":/workspace ryanmcafee/devops-cli /bin/pwsh provision.ps1 "$@"
