#!/bin/bash
# 批量处理上游最近 N 个版本：逐个发布（release.sh 内部会跳过已存在的 Release）
set -euo pipefail

org='flannel-io'
proj='flannel'
version_number=10
# release.sh 要求的 ABI 标识：abi2.0 用 loongarch64，abi1.0 用 loongarch64abi1
abi='loongarch64'

versions(){
    curl -sL "https://api.github.com/repos/${org}/${proj}/releases" | jq -r ".[].tag_name" | \
        sort -rV | \
        head -n ${version_number} | \
        sort -rV
}

batch_build() {
    local versions_=$(versions)

    for version_ in $versions_; do
        ./scripts/build_in_docker.sh $version_
    done

}

batch_upload() { 

    local versions_=$(versions)

    for version_ in $versions_; do
        gh release view ${version_} > /dev/null 2>&1 || ./scripts/release.sh $version_ ${abi}
    done

}

batch_upload
