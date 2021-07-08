/**
 * Copyright 2015 @ to2.net.
 * name : shipment_rep
 * author : jarryliu
 * date : 2016-07-15 10:28
 * description :
 * history :
 */
package repos

import (
	"github.com/ixre/gof/db"
	"github.com/ixre/gof/db/orm"
	"go2o/core/domain/interface/express"
	"go2o/core/domain/interface/shipment"
	shipImpl "go2o/core/domain/shipment"
)

var _ shipment.IShipmentRepo = new(shipmentRepo)

type shipmentRepo struct {
	_expRepo express.IExpressRepo
	db.Connector
	o orm.Orm
}

func NewShipmentRepo(o orm.Orm, expRepo express.IExpressRepo) *shipmentRepo {
	return &shipmentRepo{
		Connector: o.Connector(),
		o:         o,
		_expRepo:  expRepo,
	}
}

// 创建发货单
func (s *shipmentRepo) CreateShipmentOrder(o *shipment.ShipmentOrder) shipment.IShipmentOrder {
	return shipImpl.NewShipmentOrder(o, s, s._expRepo)
}

func (s *shipmentRepo) getShipOrderById(id int64) *shipment.ShipmentOrder {
	e := &shipment.ShipmentOrder{}
	if s.o.Get(id, e) == nil {
		return e
	}
	return nil
}

// 获取发货单
func (s *shipmentRepo) GetShipmentOrder(id int64) shipment.IShipmentOrder {
	if e := s.getShipOrderById(id); e != nil {
		return s.CreateShipmentOrder(e)
	}
	return nil
}

// 获取订单对应的发货单
func (s *shipmentRepo) GetShipOrders(orderId int64, sub bool) []shipment.IShipmentOrder {
	var list []*shipment.ShipmentOrder
	if sub {
		s.o.Select(&list, "sub_orderid= $1", orderId)
	} else {
		s.o.Select(&list, "order_id= $1", orderId)
	}
	orders := make([]shipment.IShipmentOrder, len(list))
	for i, v := range list {
		v.Items = s.loadItems(v.ID)
		orders[i] = s.CreateShipmentOrder(v)
	}
	return orders
}

// 保存发货单
func (s *shipmentRepo) SaveShipmentOrder(o *shipment.ShipmentOrder) (int, error) {
	return orm.Save(s.o, o, int(o.ID))
}

// 保存发货商品项
func (s *shipmentRepo) SaveShipmentItem(v *shipment.ShipmentItem) (int, error) {
	return orm.Save(s.o, v, int(v.ID))
}

// 删除发货单
func (s *shipmentRepo) DeleteShipmentOrder(id int64) error {
	return s.o.DeleteByPk(&shipment.ShipmentOrder{}, id)
}

func (s *shipmentRepo) loadItems(shipOrderId int64) []*shipment.ShipmentItem {
	var list []*shipment.ShipmentItem
	_ = s.o.Select(&list, "ship_order = $1", shipOrderId)
	return list
}
