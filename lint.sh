#!/usr/bin/env bash

# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# If running in prow, set up the dependencies and default checkout folder.
if [[ -n "${PROW_JOB_ID:-}" ]]; then
    mkdir /home/prow/go/src/sigs.k8s.io
    ln -s "${PWD}" /home/prow/go/src/sigs.k8s.io/k8s-container-image-promoter
    cd /home/prow/go/src/sigs.k8s.io/k8s-container-image-promoter
    export GO111MODULE=on
    go version
    go mod download
fi

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

echo "=== Linting ==="
cd "${SCRIPT_ROOT}"
if golangci-lint run; then
    echo "PASS"
else
    err=$?
    echo >&2 "FAIL"
    exit "${err}"
fi
