package wholesaler

/* 批发商 */

type (
	// 批发商
	IWholesaler interface {
		// 获取领域编号
		GetDomainId() int64
		// 获取值
		Value() *WsWholesaler
		// 审核批发商
		Review(pass bool, reason string) error
		// 停止批发权限
		Abort() error
		// 保存
		Save() (int32, error)
		// 同步商品,返回同步结果
		SyncItems(syncPrice bool) (result map[string]int32)
		// 保存客户分组的批发返点率
		SaveGroupRebateRate(groupId int32, arr []*WsRebateRate) error
		// 获取客户分组的批发返点率
		GetGroupRebateRate(groupId int32) []*WsRebateRate
		// 获取批发返点率
		GetRebateRate(groupId int32, amount int32) float64
	}

	IWholesaleRepo interface {
		// Get WsWholesaler
		GetWsWholesaler(primary interface{}) *WsWholesaler
		// Save WsWholesaler
		SaveWsWholesaler(v *WsWholesaler, create bool) (int, error)
		// 同步商品
		SyncItems(mchId int64, shelve, review int32) (add int, del int)
		// 获取待同步的商品编号
		GetAwaitSyncItems(vendorId int64) (add []int)

		// Select WsRebateRate
		SelectWsRebateRate(where string, v ...interface{}) []*WsRebateRate
		// Save WsRebateRate
		SaveWsRebateRate(v *WsRebateRate) (int, error)
		// Batch Delete WsRebateRate
		BatchDeleteWsRebateRate(where string, v ...interface{}) (int64, error)
	}
	// 批发商
	WsWholesaler struct {
		// 供货商编号等于供货商（等同与商户编号)
		MchId int64 `db:"mch_id" pk:"yes" auto:"yes"`
		// 批发商评级
		Rate int `db:"rate"`
		// 批发商审核状态
		ReviewState int32 `db:"review_state"`
	}
	// 批发客户分组返点比例设置
	WsRebateRate struct {
		// 编号
		ID int32 `db:"id" pk:"yes" auto:"yes"`
		// 批发商编号
		WsId int32 `db:"ws_id"`
		// 客户分组编号
		BuyerGid int32 `db:"buyer_gid"`
		// 下限金额
		RequireAmount int32 `db:"require_amount"`
		// 返点率
		RebateRate float64 `db:"rebate_rate"`
	}
)
