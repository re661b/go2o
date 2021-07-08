package repos

import (
	"github.com/ixre/gof/db/orm"
	"github.com/ixre/gof/storage"
	"go2o/core/domain/interface/ad"
	"go2o/core/domain/interface/after-sales"
	"go2o/core/domain/interface/cart"
	"go2o/core/domain/interface/content"
	"go2o/core/domain/interface/delivery"
	"go2o/core/domain/interface/express"
	"go2o/core/domain/interface/item"
	"go2o/core/domain/interface/member"
	"go2o/core/domain/interface/merchant"
	"go2o/core/domain/interface/merchant/shop"
	"go2o/core/domain/interface/merchant/user"
	"go2o/core/domain/interface/merchant/wholesaler"
	"go2o/core/domain/interface/mss"
	"go2o/core/domain/interface/mss/notify"
	"go2o/core/domain/interface/order"
	"go2o/core/domain/interface/payment"
	"go2o/core/domain/interface/personfinance"
	"go2o/core/domain/interface/pro_model"
	"go2o/core/domain/interface/product"
	"go2o/core/domain/interface/promotion"
	"go2o/core/domain/interface/registry"
	"go2o/core/domain/interface/shipment"
	"go2o/core/domain/interface/valueobject"
	"go2o/core/domain/interface/wallet"
)

var (
	Repo = &RepoFactory{}
)

type RepoFactory struct {
	registryRepo registry.IRegistryRepo
	proMRepo     promodel.IProductModelRepo
	valueRepo    valueobject.IValueRepo
	userRepo     user.IUserRepo
	notifyRepo   notify.INotifyRepo
	mssRepo      mss.IMssRepo

	expressRepo express.IExpressRepo
	shipRepo    shipment.IShipmentRepo
	memberRepo  member.IMemberRepo
	productRepo product.IProductRepo
	itemWsRepo  item.IItemWholesaleRepo
	catRepo     product.ICategoryRepo
	itemRepo    item.IGoodsItemRepo
	tagSaleRepo item.ISaleLabelRepo
	promRepo    promotion.IPromotionRepo

	shopRepo          shop.IShopRepo
	wholesaleRepo     wholesaler.IWholesaleRepo
	mchRepo           merchant.IMerchantRepo
	cartRepo          cart.ICartRepo
	personFinanceRepo personfinance.IPersonFinanceRepository
	deliveryRepo      delivery.IDeliveryRepo
	contentRepo       content.IContentRepo
	adRepo            ad.IAdRepo
	orderRepo         order.IOrderRepo
	paymentRepo       payment.IPaymentRepo
	asRepo            afterSales.IAfterSalesRepo

	walletRepo wallet.IWalletRepo
	_orm       orm.Orm
}

func (r *RepoFactory) Init(o orm.Orm, sto storage.Interface) *RepoFactory {
	r._orm = o
	Repo = r

	/** Repository **/
	r.registryRepo = NewRegistryRepo(o, sto)
	r.proMRepo = NewProModelRepo(o)
	r.valueRepo = NewValueRepo("", o, sto)
	r.userRepo = NewUserRepo(o)
	r.walletRepo = NewWalletRepo(o)
	r.notifyRepo = NewNotifyRepo(o, r.registryRepo)
	r.mssRepo = NewMssRepo(o, r.notifyRepo, r.registryRepo, r.valueRepo)
	r.expressRepo = NewExpressRepo(o, r.valueRepo)
	r.shipRepo = NewShipmentRepo(o, r.expressRepo)
	r.memberRepo = NewMemberRepo(sto, o, r.walletRepo, r.mssRepo, r.valueRepo, r.registryRepo)
	r.productRepo = NewProductRepo(o, r.proMRepo, r.valueRepo)
	r.itemWsRepo = NewItemWholesaleRepo(o)
	r.catRepo = NewCategoryRepo(o, r.registryRepo, sto)
	r.shopRepo = NewShopRepo(o, sto, r.valueRepo, r.registryRepo)
	r.itemRepo = NewGoodsItemRepo(o, r.catRepo, r.productRepo,
		r.proMRepo, r.itemWsRepo, r.expressRepo, r.registryRepo, r.shopRepo)
	r.tagSaleRepo = NewTagSaleRepo(o, r.valueRepo)
	r.promRepo = NewPromotionRepo(o, r.itemRepo, r.memberRepo)

	//afterSalesRepo := repository.NewAfterSalesRepo(o)
	r.wholesaleRepo = NewWholesaleRepo(o)
	r.mchRepo = NewMerchantRepo(o, sto, r.wholesaleRepo,
		r.itemRepo, r.shopRepo, r.userRepo, r.memberRepo, r.mssRepo, r.walletRepo, r.valueRepo, r.registryRepo)
	r.cartRepo = NewCartRepo(o, r.memberRepo, r.mchRepo, r.itemRepo)
	r.personFinanceRepo = NewPersonFinanceRepository(o, r.memberRepo)
	r.deliveryRepo = NewDeliverRepo(o)
	r.contentRepo = NewContentRepo(o)
	r.adRepo = NewAdvertisementRepo(o, sto)
	r.orderRepo = NewOrderRepo(sto, o, r.mchRepo, nil,
		r.productRepo, r.cartRepo, r.itemRepo, r.promRepo, r.memberRepo,
		r.deliveryRepo, r.expressRepo, r.shipRepo, r.valueRepo, r.registryRepo)
	r.paymentRepo = NewPaymentRepo(sto, o, r.memberRepo, r.orderRepo, r.registryRepo)
	r.asRepo = NewAfterSalesRepo(o, r.orderRepo, r.memberRepo, r.paymentRepo)

	// 解决依赖
	r.orderRepo.(*OrderRepImpl).SetPaymentRepo(r.paymentRepo)
	// 初始化数据
	r.memberRepo.GetManager().GetAllBuyerGroups()
	return r
}

func (r *RepoFactory) GetOrm() orm.Orm {
	return r._orm
}

func (r *RepoFactory) GetProModelRepo() promodel.IProductModelRepo {
	return r.proMRepo
}

func (r *RepoFactory) GetValueRepo() valueobject.IValueRepo {
	return r.valueRepo
}
func (r *RepoFactory) GetUserRepo() user.IUserRepo {
	return r.userRepo
}
func (r *RepoFactory) GetNotifyRepo() notify.INotifyRepo {
	return r.notifyRepo
}
func (r *RepoFactory) GetMssRepo() mss.IMssRepo {
	return r.mssRepo
}
func (r *RepoFactory) GetExpressRepo() express.IExpressRepo {
	return r.expressRepo
}
func (r *RepoFactory) GetShipmentRepo() shipment.IShipmentRepo {
	return r.shipRepo
}
func (r *RepoFactory) GetMemberRepo() member.IMemberRepo {
	return r.memberRepo
}
func (r *RepoFactory) GetProductRepo() product.IProductRepo {
	return r.productRepo
}
func (r *RepoFactory) GetItemWholesaleRepo() item.IItemWholesaleRepo {
	return r.itemWsRepo
}
func (r *RepoFactory) GetCategoryRepo() product.ICategoryRepo {
	return r.catRepo
}
func (r *RepoFactory) GetItemRepo() item.IGoodsItemRepo {
	return r.itemRepo
}
func (r *RepoFactory) GetSaleLabelRepo() item.ISaleLabelRepo {
	return r.tagSaleRepo
}
func (r *RepoFactory) GetPromotionRepo() promotion.IPromotionRepo {
	return r.promRepo
}
func (r *RepoFactory) GetShopRepo() shop.IShopRepo {
	return r.shopRepo
}
func (r *RepoFactory) GetWholesaleRepo() wholesaler.IWholesaleRepo {
	return r.wholesaleRepo
}
func (r *RepoFactory) GetMerchantRepo() merchant.IMerchantRepo {
	return r.mchRepo
}
func (r *RepoFactory) GetCartRepo() cart.ICartRepo {
	return r.cartRepo
}
func (r *RepoFactory) GetPersonFinanceRepository() personfinance.IPersonFinanceRepository {
	return r.personFinanceRepo
}
func (r *RepoFactory) GetDeliveryRepo() delivery.IDeliveryRepo {
	return r.deliveryRepo
}
func (r *RepoFactory) GetContentRepo() content.IContentRepo {
	return r.contentRepo
}
func (r *RepoFactory) GetAdRepo() ad.IAdRepo {
	return r.adRepo
}
func (r *RepoFactory) GetOrderRepo() order.IOrderRepo {
	return r.orderRepo
}
func (r *RepoFactory) GetPaymentRepo() payment.IPaymentRepo {
	return r.paymentRepo
}
func (r *RepoFactory) GetAfterSalesRepo() afterSales.IAfterSalesRepo {
	return r.asRepo
}
func (r *RepoFactory) GetWalletRepo() wallet.IWalletRepo {
	return r.walletRepo
}

func (r *RepoFactory) GetRegistryRepo() registry.IRegistryRepo {
	return r.registryRepo
}
