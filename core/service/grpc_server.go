package service

import (
	"fmt"
	"github.com/ixre/gof"
	"github.com/ixre/gof/log"
	"go.etcd.io/etcd/clientv3"
	grpc2 "go2o/core/service/impl"
	"go2o/core/service/proto"
	"google.golang.org/grpc"
	"net"
	"strconv"
)

/**
 * Copyright (C) 2007-2020 56X.NET,All rights reserved.
 *
 * name : grpc_server
 * author : jarrysix (jarrysix#gmail.com)
 * date : 2020-09-03 17:03
 * description :
 * history :
 */

func ServeRPC(ch chan bool, cfg *clientv3.Config, port int) {
	// 初始化RPC服务
	prepareRpcServer(gof.CurrentApp)
	// 初始化数据
	sysInit()
	// 启动RPC服务
	s := grpc.NewServer()
	proto.RegisterGreeterServiceServer(s, &grpc2.TestServiceImpl{})
	proto.RegisterStatusServiceServer(s, grpc2.StatusService)
	proto.RegisterRegistryServiceServer(s, grpc2.RegistryService)
	proto.RegisterMerchantServiceServer(s, grpc2.MerchantService)
	proto.RegisterMemberServiceServer(s, grpc2.MemberService)
	proto.RegisterFoundationServiceServer(s, grpc2.FoundationService)
	proto.RegisterMessageServiceServer(s, grpc2.MessageService)
	proto.RegisterContentServiceServer(s, grpc2.ContentService)
	proto.RegisterPaymentServiceServer(s, grpc2.PaymentService)
	proto.RegisterWalletServiceServer(s, grpc2.WalletService)
	proto.RegisterCartServiceServer(s, grpc2.CartService)
	proto.RegisterOrderServiceServer(s, grpc2.ShoppingService)
	proto.RegisterShopServiceServer(s, grpc2.ShopService)
	proto.RegisterShipmentServiceServer(s, grpc2.ShipmentService)
	proto.RegisterItemServiceServer(s, grpc2.ItemService)
	proto.RegisterFinanceServiceServer(s, grpc2.PersonFinanceService)
	proto.RegisterQueryServiceServer(s, grpc2.QueryService)
	proto.RegisterProductServiceServer(s, grpc2.ProductService)
	proto.RegisterAfterSalesServiceServer(s, grpc2.AfterSalesService)
	proto.RegisterExpressServiceServer(s, grpc2.ExpressService)
	proto.RegisterAdvertisementServiceServer(s, grpc2.AdService)
	// standalone service
	proto.RegisterQuickPayServiceServer(s, grpc2.QuickPayService)
	proto.RegisterAppServiceServer(s, grpc2.AppService)
	proto.RegisterRbacServiceServer(s, grpc2.RbacService)
	registerServiceDiscovery(cfg, port)
	go serveRPC(ch, s, port)
}

func serveRPC(ch chan bool, s *grpc.Server, port int) {
	l, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		panic(err)
	}
	log.Println("[ Go2o][ API]: grpc node serve on port :" + strconv.Itoa(port))
	if err = s.Serve(l); err != nil {
		ch <- false
		panic(err)
	}
}
