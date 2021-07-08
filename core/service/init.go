package service

import (
	"fmt"
	"github.com/ixre/gof/crypto"
	"github.com/ixre/gof/util"
	"go2o/core/domain/interface/registry"
	"go2o/core/infrastructure/domain"
	"go2o/core/service/impl"
	"log"
	"strings"
)

/**
 * Copyright (C) 2007-2020 56X.NET,All rights reserved.
 *
 * name : init.go
 * author : jarrysix (jarrysix#gmail.com)
 * date : 2020-11-14 11:35
 * description :
 * history :
 */

func sysInit() {
	repo := impl.Repos.GetRegistryRepo()
	initJWTSecret(repo)
	initSuperLoginToken(repo)
}

func initSuperLoginToken(repo registry.IRegistryRepo) {
	value, _ := repo.GetValue(registry.SysSuperLoginToken)
	if strings.TrimSpace(value) == "" {
		pwd := util.RandString(8)
		log.Println(fmt.Sprintf("[ Go2o][ Info]: the initial super pwd is '%s', it only show first time. plese save it.", pwd))
		token := domain.Sha1("master" + crypto.Md5([]byte(pwd)))
		_ = repo.UpdateValue(registry.SysSuperLoginToken, token)
	}

}

// 初始化jwt密钥
func initJWTSecret(repo registry.IRegistryRepo) {
	value, _ := repo.GetValue(registry.SysJWTSecret)
	if strings.TrimSpace(value) == "" {
		_, privateKey, _ := crypto.GenRsaKeys(2048)
		_ = repo.UpdateValue(registry.SysJWTSecret, privateKey)
	}
}
