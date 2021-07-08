#!/bin/bash

# generate api docs
rm -rf api_docs &&
  apidoc -i $(find . -name 'apidoc.json' -print -quit | xargs dirname) -o api_docs/

if [[ $GO2O_JAVA_HOME != "" ]]; then java_target_path=$GO2O_JAVA_HOME; fi

#cmd=$1

PROTO_PATH=$(find . -name "idl" -print -quit)
TARGET_PATH=$PROTO_PATH/../proto
rm -rf "$TARGET_PATH"wq && mkdir -p "$TARGET_PATH"
protoc -I "$PROTO_PATH" --go_out=plugins=grpc:"$TARGET_PATH" "$PROTO_PATH"/**/*.proto
protoc -I "$PROTO_PATH" --go_out=plugins=grpc:"$TARGET_PATH" "$PROTO_PATH"/*.proto
find "${TARGET_PATH}" -name "*.pb.go"|xargs -I{} sed -i "s/,omitempty//g" {}
#if [[ ${cmd} = "all" ]] || [[ ${cmd} = "format" ]];then
#	cd ${go_target_path}
#fi
