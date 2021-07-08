/**
 * Copyright 2015 @ at3.net.
 * name : sso.go
 * author : jarryliu
 * date : 2016-11-25 13:02
 * description :
 * history :
 */
package module

import (
	"errors"
	"github.com/ixre/gof"
	"github.com/ixre/gof/crypto"
	"go2o/core/domain/interface/registry"
	"go2o/core/repos"
	"go2o/core/service/proto"
	"strings"
)

var _ Module = new(SSOModule)

//todo: 去掉rpc

type SSOModule struct {
	app          gof.App
	appMap       map[string]*proto.SSsoApp
	apiUrlArray  []string
	registryRepo registry.IRegistryRepo
}

// 模块数据
func (s *SSOModule) SetApp(app gof.App) {
	s.app = app
}

// 初始化模块
func (s *SSOModule) Init() {
	s.appMap = make(map[string]*proto.SSsoApp)
	s.registryRepo = repos.Repo.GetRegistryRepo()
}

func (s *SSOModule) Register(app *proto.SSsoApp) (token string, err error) {
	if app.Name == "" {
		return "", errors.New("-1:serve name is null")
	}
	if app.ApiUrl == "" {
		return "", errors.New("-2:api url is null")
	}
	if prefixRight := strings.HasPrefix(app.ApiUrl, "//") ||
		strings.HasPrefix(app.ApiUrl, "http://") ||
		strings.HasPrefix(app.ApiUrl, "https://"); !prefixRight {
		return "", errors.New("-3:api url error")
	}
	if _, ok := s.appMap[app.Name]; ok {
		return "", errors.New("-4:serve has be resisted")
	}
	// 生成TOKEN
	app.Token = crypto.Md5([]byte(app.Name + "#" + app.ApiUrl))
	// 注册
	s.apiUrlArray = nil
	s.appMap[app.Name] = app
	// 清除缓存
	s.apiUrlArray = nil
	return app.Token, nil

}

// 获取APP的配置
func (s *SSOModule) Get(name string) *proto.SSsoApp {
	if s.appMap != nil {
		return s.appMap[name]
	}
	return nil
}

// 返回同步的应用API地址
func (s *SSOModule) Array() []string {
	if s.apiUrlArray == nil && s.appMap != nil && len(s.appMap) > 0 {
		s.apiUrlArray = make([]string, len(s.appMap))
		i := 0
		for _, v := range s.appMap {
			s.apiUrlArray[i] = s.formatApi(v.ApiUrl, v.Token)
			i++
		}
	}
	return s.apiUrlArray
}

// 格式化API地址，加上token参数
func (s *SSOModule) formatApi(api string, token string) string {
	arr := []string{api}
	if strings.Index(api, "?") == -1 {
		arr = append(arr, "?")
	} else {
		arr = append(arr, "&")
	}
	arr = append(arr, "sso_token=")
	arr = append(arr, token)
	return strings.Join(arr, "")
}
