/**
 * Copyright 2015 @ to2.net.
 * name : category
 * author : jarryliu
 * date : -- :
 * description :
 * history :
 */
package util

import (
	"github.com/ixre/gof/algorithm/iterator"
	"go2o/core/service/proto"
)

type CategoryFormatFunc func(c *proto.SProductCategory, level int)

// 遍历栏目
func IterateCategory(categories []*proto.SProductCategory, c *proto.SProductCategory,
	iterateFunc CategoryFormatFunc, finishFunc CategoryFormatFunc, level int) {
	if c.Id != 0 {
		iterateFunc(c, level)
	}

	for _, k := range categories {
		if k.ParentId == c.Id {
			IterateCategory(categories, k, iterateFunc, finishFunc, level+1)
		}
	}

	if finishFunc != nil {
		finishFunc(c, level)
	}

}

// 迭代栏目
func WalkSaleCategory(cs []*proto.SProductCategory, v *proto.SProductCategory, start iterator.WalkFunc, over iterator.WalkFunc) {
	var condition iterator.Condition = func(v, v1 interface{}) bool {
		return v1.(*proto.SProductCategory).ParentId == v.(*proto.SProductCategory).Id
	}
	var arr = make([]interface{}, len(cs))
	for i, v := range cs {
		arr[i] = v
	}
	iterator.Walk(arr, v, condition, start, over, 0)
}

// 迭代栏目
func WalkArticleCategory(cs *proto.ArticleCategoriesResponse, v *proto.SArticleCategory, start iterator.WalkFunc, over iterator.WalkFunc) {
	var condition iterator.Condition = func(v, v1 interface{}) bool {
		return v1.(*proto.SArticleCategory).ParentId ==
			v.(*proto.SArticleCategory).Id
	}
	var arr = make([]interface{}, len(cs.Value))
	for i, v := range cs.Value {
		arr[i] = v
	}
	iterator.Walk(arr, v, condition, start, over, 0)
}
