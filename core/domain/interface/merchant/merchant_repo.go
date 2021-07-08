/**
 * Copyright 2014 @ to2.net.
 * name :
 * author : jarryliu
 * date : 2013-12-12 16:52
 * description :
 * history :
 */

package merchant

type IMerchantRepo interface {
	// 获取商户管理器
	GetManager() IMerchantManager

	CreateMerchant(*Merchant) IMerchant

	// 创建会员申请商户密钥
	CreateSignUpToken(memberId int64) string

	// 根据商户申请密钥获取会员编号
	GetMemberFromSignUpToken(token string) int64

	// 获取商户的编号
	GetMerchantsId() []int32

	// 获取商户
	GetMerchant(id int) IMerchant
	// 根据登录用户名获取商户
	GetMerchantByLoginUser(user string) IMerchant
	// 获取合作商主要的域名主机
	GetMerchantMajorHost(mchId int) string

	// 保存
	SaveMerchant(*Merchant) (int, error)

	// 获取账户
	GetAccount(mchId int) *Account

	// 获取销售配置
	GetMerchantSaleConf(mchId int64) *SaleConf

	// 保存销售配置
	SaveMerchantSaleConf(v *SaleConf) error

	// 保存商户账户信息
	UpdateAccount(v *Account) error

	// 保存API信息
	SaveApiInfo(d *ApiInfo) error

	// 获取API信息
	GetApiInfo(mchId int) *ApiInfo

	// 根据API编号获取商户编号
	GetMerchantIdByApiId(apiId string) int64

	// 获取键值
	GetKeyValue(mchId int, indent string, k string) string

	// 设置键值
	SaveKeyValue(mchId int, indent string, k, v string, updateTime int64) error

	// 获取多个键值
	GetKeyMap(mchId int, indent string, k []string) map[string]string

	// 检查是否包含值的键数量,keyStr为键模糊匹配
	CheckKvContainValue(mchId int, indent string, value string, keyStr string) int

	// 根据关键字获取字典
	GetKeyMapByChar(mchId int, indent string, keyword string) map[string]string

	//获取等级
	GetLevel(mchId, levelValue int32) *MemberLevel

	// 获取下一个等级
	GetNextLevel(mchId, levelVal int32) *MemberLevel

	// 获取会员等级
	GetMemberLevels(mchId int64) []*MemberLevel

	// 删除会员等级
	DeleteMemberLevel(mchId, id int32) error

	// 保存等级
	SaveMemberLevel(mchId int64, v *MemberLevel) (int32, error)

	// Get MchEnterpriseInfo
	GetMchEnterpriseInfo(mchId int) *EnterpriseInfo
	// Save MchEnterpriseInfo
	SaveMchEnterpriseInfo(v *EnterpriseInfo) (int, error)

	// Get MchBuyerGroupSetting
	GetMchBuyerGroupByGroupId(mchId, groupId int32) *MchBuyerGroupSetting
	// Select MchBuyerGroupSetting
	SelectMchBuyerGroup(mchId int64) []*MchBuyerGroupSetting
	// Save MchBuyerGroupSetting
	SaveMchBuyerGroup(v *MchBuyerGroupSetting) (int, error)

	// auto generate by gof
	// Get MchTradeConf
	GetMchTradeConf(primary interface{}) *TradeConf
	// GetBy MchTradeConf
	GetMchTradeConfBy(where string, v ...interface{}) *TradeConf
	// Select MchTradeConf
	SelectMchTradeConf(where string, v ...interface{}) []*TradeConf
	// Save MchTradeConf
	SaveMchTradeConf(v *TradeConf) (int, error)
	// Delete MchTradeConf
	DeleteMchTradeConf(primary interface{}) error
	// 验证商户用户名是否存在
	CheckUserExists(user string, id int) bool
	// 验证会员是否绑定商户
	CheckMemberBind(memberId int64) bool

	//  //修改线下支付利润
	//UpdateMechOfflineRate(id int, rate float32, return_rate float32) error
	////商户提现日志
	//SaveMachBlanceLog(v *BalanceLog) error
	////个人提现日志
	//SavePresionBlanceLog(v *member.PresentLog) error
	//
	//GetOfflineRate(id int32) (float32, float32, error)
}
