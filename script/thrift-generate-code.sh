#!/bin/bash

# generate api docs
rm -rf api_docs &&
  apidoc -i $(find . -name 'apidoc.json' -print -quit | xargs dirname) -o api_docs/

# 生成服务代码
# author : liuming
# data   : 2017-11-26 11:00

java_target_path="./tmp/java"
cs_target_path="./tmp/csharp"

if [[ $GO2O_JAVA_HOME != "" ]]; then java_target_path=$GO2O_JAVA_HOME; fi

thrift_path=$(find . -name "service.thrift" -print -quit)

cmd=$1
if [[ ${cmd} == "csharp" || ${cmd} == "all" ]]; then
  rm -rf ${cs_target_path}/*
  thrift -r -gen csharp -out ${cs_target_path} ${thrift_path}
fi

if [[ ${cmd} == "java" || ${cmd} == "all" ]]; then
  mkdir -p ${java_target_path}
  rm -rf ${java_target_path}/proto/*
  thrift -r -gen java -out ${java_target_path} ${thrift_path}
fi

#if [[ ${cmd} = "go" || ${cmd} = "all" ]];then
rm -rf ./go2o/core/service/thrift/auto_gen/rpc
thrift -r -gen go -out ../ ${thrift_path}
#fi

if [[ ${cmd} == "all" ]] || [[ ${cmd} == "format" ]]; then
  cd ${go_target_path}
  #find ./ -name *.go |xargs sed -i \
  #	 's/"ttype"/"go2o\/core\/service\/auto-gen\/thrift\/ttype"/g'
  #find ./ -name *.go |xargs sed -i \
  #	 's/"\(.\{3,\}\)_service"/"go2o\/core\/service\/auto-gen\/thrift\/\1_service"/g'

  #cd - >/dev/null

fi
