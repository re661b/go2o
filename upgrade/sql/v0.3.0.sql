-- 更换为POSTGRESQL --
ALTER TABLE "public".mm_member ADD COLUMN flag int4 DEFAULT 0 NOT NULL;

-- mm_balance_log  mm_wallet_log  mm_integral_log 表结构更改
CREATE TABLE "public".mm_integral_log (id serial NOT NULL, member_id int4 NOT NULL, kind int4 NOT NULL, title varchar(60) DEFAULT '""'::character varying NOT NULL, outer_no varchar(40) DEFAULT '""'::character varying NOT NULL, value int4 NOT NULL, remark varchar(40) NOT NULL, rel_user int4 DEFAULT 0 NOT NULL, review_state int2 DEFAULT 0 NOT NULL, create_time int8 NOT NULL, update_time int8 DEFAULT 0 NOT NULL, CONSTRAINT mm_integral_log_pkey PRIMARY KEY (id));
COMMENT ON TABLE "public".mm_integral_log IS '积分明细';
COMMENT ON COLUMN "public".mm_integral_log.id IS '编号';
COMMENT ON COLUMN "public".mm_integral_log.member_id IS '会员编号';
COMMENT ON COLUMN "public".mm_integral_log.kind IS '类型';
COMMENT ON COLUMN "public".mm_integral_log.title IS '标题';
COMMENT ON COLUMN "public".mm_integral_log.outer_no IS '关联的编号';
COMMENT ON COLUMN "public".mm_integral_log.value IS '积分值';
COMMENT ON COLUMN "public".mm_integral_log.remark IS '备注';
COMMENT ON COLUMN "public".mm_integral_log.rel_user IS '关联用户';
COMMENT ON COLUMN "public".mm_integral_log.review_state IS '审核状态';
COMMENT ON COLUMN "public".mm_integral_log.create_time IS '创建时间';
COMMENT ON COLUMN "public".mm_integral_log.update_time IS '更新时间';

CREATE INDEX mm_member_code ON "public".mm_member (code);
CREATE INDEX mm_member_user ON "public".mm_member ("user");

ALTER TABLE "public".mm_member ADD COLUMN avatar varchar(80) DEFAULT '' NOT NULL;
ALTER TABLE "public".mm_member ADD COLUMN phone varchar(15) DEFAULT '' NOT NULL;
 ALTER TABLE "public".mm_member ADD COLUMN email varchar(50) DEFAULT '' NOT NULL;
COMMENT ON COLUMN "public".mm_member.flag IS '会员标志';


ALTER TABLE "public".mm_member ADD COLUMN name varchar(20) DEFAULT '' NOT NULL;
  COMMENT ON COLUMN "public".mm_member.name IS '昵称';

CREATE TABLE mm_flow_log (id serial NOT NULL, member_id int4 NOT NULL, kind int2 NOT NULL, title varchar(60) NOT NULL, outer_no varchar(40) NOT NULL, amount float8 NOT NULL, csn_fee float8 NOT NULL, review_state int2 DEFAULT 0 NOT NULL, rel_user int4 NOT NULL, remark varchar(60) NOT NULL, create_time int4 NOT NULL, update_time int4 NOT NULL, PRIMARY KEY (id));
COMMENT ON TABLE mm_flow_log IS '活动账户明细';
COMMENT ON COLUMN mm_flow_log.id IS '编号';
COMMENT ON COLUMN mm_flow_log.member_id IS '会员编号';
COMMENT ON COLUMN mm_flow_log.kind IS '类型';
COMMENT ON COLUMN mm_flow_log.title IS '标题';
COMMENT ON COLUMN mm_flow_log.outer_no IS '外部交易号';
COMMENT ON COLUMN mm_flow_log.amount IS '金额';
COMMENT ON COLUMN mm_flow_log.csn_fee IS '手续费';
COMMENT ON COLUMN mm_flow_log.review_state IS '审核状态';
COMMENT ON COLUMN mm_flow_log.rel_user IS '关联用户';
COMMENT ON COLUMN mm_flow_log.remark IS '备注';
COMMENT ON COLUMN mm_flow_log.create_time IS '创建时间';
COMMENT ON COLUMN mm_flow_log.update_time IS '更新时间';


/** --- 会员关系: mm_relation,  删除: mm_income_log */

CREATE TABLE mm_receipts_code (id  SERIAL NOT NULL, member_id int4 NOT NULL, "identity" varchar(10) NOT NULL, name varchar(10) NOT NULL, account_id varchar(40) NOT NULL, code_url varchar(120) NOT NULL, state int2 NOT NULL, PRIMARY KEY (id));
COMMENT ON TABLE mm_receipts_code IS '收款码';
COMMENT ON COLUMN mm_receipts_code.id IS '编号';
COMMENT ON COLUMN mm_receipts_code.member_id IS '会员编号';
COMMENT ON COLUMN mm_receipts_code."identity" IS '账户标识,如:alipay';
COMMENT ON COLUMN mm_receipts_code.name IS '账户名称';
COMMENT ON COLUMN mm_receipts_code.account_id IS '账号';
COMMENT ON COLUMN mm_receipts_code.code_url IS '收款码地址';
COMMENT ON COLUMN mm_receipts_code.state IS '是否启用';

/** 实名认证 */
CREATE TABLE "public".mm_trusted_info (member_id  SERIAL NOT NULL, real_name varchar(10) NOT NULL, country_code varchar(10) NOT NULL, card_type int4 NOT NULL, card_id varchar(20) NOT NULL, card_image varchar(120) NOT NULL, card_reverse_image varchar(120) DEFAULT ' ' NOT NULL, trust_image varchar(120) NOT NULL, manual_review int4 NOT NULL, review_state int2 DEFAULT 0 NOT NULL, review_time int4 NOT NULL, remark varchar(120) NOT NULL, update_time int4 NOT NULL, CONSTRAINT mm_trusted_info_pkey PRIMARY KEY (member_id));
COMMENT ON COLUMN "public".mm_trusted_info.member_id IS '会员编号';
COMMENT ON COLUMN "public".mm_trusted_info.real_name IS '真实姓名';
COMMENT ON COLUMN "public".mm_trusted_info.country_code IS '国家代码';
COMMENT ON COLUMN "public".mm_trusted_info.card_type IS '证件类型';
COMMENT ON COLUMN "public".mm_trusted_info.card_id IS '证件编号';
COMMENT ON COLUMN "public".mm_trusted_info.card_image IS '证件图片';
COMMENT ON COLUMN "public".mm_trusted_info.card_reverse_image IS '证件反面图片';
COMMENT ON COLUMN "public".mm_trusted_info.trust_image IS '认证图片,人与身份证的图像等';
COMMENT ON COLUMN "public".mm_trusted_info.manual_review IS '人工审核';
COMMENT ON COLUMN "public".mm_trusted_info.review_state IS '审核状态';
COMMENT ON COLUMN "public".mm_trusted_info.review_time IS '审核时间';
COMMENT ON COLUMN "public".mm_trusted_info.remark IS '备注';
COMMENT ON COLUMN "public".mm_trusted_info.update_time IS '更新时间';

/** invitation_code => invite_code */

/** 订单状态, break改为7, complete改为8 */


/** mm_levelup 重新创建 */
CREATE TABLE mm_levelup (
  id            SERIAL NOT NULL,
  member_id    int4 NOT NULL,
  origin_level int4 NOT NULL,
  target_level int4 NOT NULL,
  is_free      int2 NOT NULL,
  payment_id   int4 NOT NULL,
  upgrade_mode int4 NOT NULL,
  review_state int4 NOT NULL,
  create_time  int8 NOT NULL,
  PRIMARY KEY (id));
COMMENT ON TABLE mm_levelup IS '会员升级日志表';
COMMENT ON COLUMN mm_levelup.member_id IS '会员编号';
COMMENT ON COLUMN mm_levelup.origin_level IS '原来等级';
COMMENT ON COLUMN mm_levelup.target_level IS '现在等级';
COMMENT ON COLUMN mm_levelup.is_free IS '是否为免费升级的会员';
COMMENT ON COLUMN mm_levelup.payment_id IS '支付单编号';
COMMENT ON COLUMN mm_levelup.create_time IS '升级时间';

/** 会员表 */
ALTER TABLE public.mm_member
    ADD COLUMN real_name character varying(20) NOT NULL DEFAULT '' ;
COMMENT ON COLUMN public.mm_member.real_name
    IS '真实姓名';

/** 锁定信息 */
CREATE TABLE mm_lock_history (
  id         SERIAL NOT NULL,
  member_id int8 NOT NULL,
  lock_time int8 NOT NULL,
  duration  int4 NOT NULL,
  remark    varchar(64) NOT NULL,
  PRIMARY KEY (id));
COMMENT ON TABLE mm_lock_history IS '会员锁定历史';
COMMENT ON COLUMN mm_lock_history.id IS '编号';
COMMENT ON COLUMN mm_lock_history.member_id IS '会员编号';
COMMENT ON COLUMN mm_lock_history.lock_time IS '锁定时间';
COMMENT ON COLUMN mm_lock_history.duration IS '锁定持续分钟数';
COMMENT ON COLUMN mm_lock_history.remark IS '备注';
CREATE TABLE mm_lock_info (
  id           SERIAL NOT NULL,
  member_id   int8 NOT NULL,
  lock_time   int8 NOT NULL,
  unlock_time int8 NOT NULL,
  remark      varchar(64) NOT NULL,
  PRIMARY KEY (id));
COMMENT ON TABLE mm_lock_info IS '会员锁定记录';
COMMENT ON COLUMN mm_lock_info.id IS '编号';
COMMENT ON COLUMN mm_lock_info.member_id IS '会员编号';
COMMENT ON COLUMN mm_lock_info.lock_time IS '锁定时间';
COMMENT ON COLUMN mm_lock_info.unlock_time IS '解锁时间';
COMMENT ON COLUMN mm_lock_info.remark IS '备注';


/** 2019-11-11 11:02:53 */
ALTER TABLE public.mch_merchant RENAME usr TO "user";

ALTER TABLE public.mch_enterprise_info DROP COLUMN review_state;

ALTER TABLE public.mch_enterprise_info
    ADD COLUMN review_state integer;

COMMENT ON COLUMN public.mch_enterprise_info.review_state
    IS '审核状态';


ALTER TABLE public.mch_shop DROP COLUMN  shop_type;

ALTER TABLE public.mch_shop DROP COLUMN opening_state;


ALTER TABLE public.mch_shop
    ADD COLUMN shop_type integer;

COMMENT ON COLUMN public.mch_shop.shop_type
    IS '店铺类型';

ALTER TABLE public.mch_shop
    ADD COLUMN opening_state integer;

COMMENT ON COLUMN public.mch_shop.opening_state
    IS '营业状态';

/** 删除无用表 */
DROP TABLE gs_item_tag;
DROP TABLE gs_category;
DROP TABLE gs_sale_snapshot;
DROP TABLE gs_sale_tag;
DROP TABLE gs_snapshot;
DROP TABLE gs_item;
DROP TABLE gs_goods;
DROP TABLE gc_order_confirm;
DROP TABLE gc_member;
DROP TABLE pt_page;
DROP TABLE pt_positions;
DROP TABLE pt_shop;

DROP TABLE pt_saleconf;
DROP TABLE pt_order_log;
DROP TABLE pt_order_item;
DROP TABLE pt_order;
DROP TABLE pt_kvset_member;
DROP TABLE pt_kvset;
DROP TABLE pt_api;
DROP TABLE pt_siteconf;

ALTER TABLE public.mch_shop
    DROP COLUMN state;

ALTER TABLE public.mch_shop
    ADD COLUMN state int2;

COMMENT ON COLUMN public.mch_shop.state
    IS '状态 1:表示正常,2:表示关闭 ';

ALTER TABLE public.mch_saleconf
    RENAME TO mch_sale_conf;

TRUNCATE TABLE "mch_online_shop";


ALTER TABLE "public".mch_online_shop
    DROP CONSTRAINT mch_online_shop_pkey;
ALTER TABLE "public".mch_online_shop
    ADD COLUMN id int4 NOT NULL;
ALTER TABLE "public".mch_online_shop
    ADD COLUMN vendor_id int4 NOT NULL;
ALTER TABLE "public".mch_online_shop
    ADD COLUMN create_time int8 NOT NULL;
ALTER TABLE "public".mch_online_shop
    ADD COLUMN state int2 NOT NULL;
ALTER TABLE "public".mch_online_shop
    ADD COLUMN shop_name varchar(20) NOT NULL;
ALTER TABLE "public".mch_online_shop
    ADD PRIMARY KEY(id);
COMMENT ON COLUMN "public".mch_online_shop.id IS '店铺编号';
COMMENT ON COLUMN "public".mch_online_shop.vendor_id IS '商户编号';
COMMENT ON COLUMN "public".mch_online_shop.host IS '自定义 域名';
COMMENT ON COLUMN "public".mch_online_shop.alias IS '个性化域名';
COMMENT ON COLUMN "public".mch_online_shop.logo IS '店铺标志';
COMMENT ON COLUMN "public".mch_online_shop.shop_name IS '店铺名称';
COMMENT ON COLUMN "public".mch_online_shop.state IS '状态';
COMMENT ON COLUMN "public".mch_online_shop.create_time IS '创建时间';
ALTER TABLE "public".mch_online_shop
    ADD UNIQUE (id);


ALTER TABLE public.mch_online_shop DROP COLUMN shop_id;

TRUNCATE TABLE "mch_merchant";

ALTER TABLE "public".mch_merchant
    alter column member_id set not null;
ALTER TABLE "public".mch_merchant
    ADD COLUMN login_user varchar(20) NOT NULL;
ALTER TABLE "public".mch_merchant
    ADD COLUMN login_pwd varchar(45) NOT NULL;
ALTER TABLE "public".mch_merchant
    alter column name set not null;
ALTER TABLE "public".mch_merchant
    alter column company_name set not null;
ALTER TABLE "public".mch_merchant
    alter column self_sales set not null;
ALTER TABLE "public".mch_merchant
    alter column level set not null;
ALTER TABLE "public".mch_merchant
    alter column logo set not null;
ALTER TABLE "public".mch_merchant
    alter column province set not null;
ALTER TABLE "public".mch_merchant
    alter column city set not null;
ALTER TABLE "public".mch_merchant
    alter column district set not null;
ALTER TABLE "public".mch_merchant
    alter column join_time set not null;
ALTER TABLE "public".mch_merchant
    alter column enabled set not null;
ALTER TABLE "public".mch_merchant
    alter column expires_time set not null;
ALTER TABLE "public".mch_merchant
    alter column update_time set not null;
ALTER TABLE "public".mch_merchant
    alter column login_time set not null;
ALTER TABLE "public".mch_merchant
    alter column last_login_time set not null;
COMMENT ON COLUMN "public".mch_merchant.company_name IS '公司名称';
COMMENT ON COLUMN "public".mch_merchant.level IS '商户等级';
COMMENT ON COLUMN "public".mch_merchant.last_login_time IS '标志';

ALTER TABLE public.mch_merchant DROP COLUMN "user";
ALTER TABLE public.mch_merchant DROP COLUMN "pwd";

ALTER TABLE "public".mch_merchant
    ADD COLUMN create_time int4 NOT NULL;
ALTER TABLE "public".mch_merchant
    ADD COLUMN flag int4 NOT NULL;
COMMENT ON TABLE "public".mch_merchant IS '商户';
COMMENT ON COLUMN "public".mch_merchant.member_id IS '会员编号';
COMMENT ON COLUMN "public".mch_merchant.login_user IS '登录用户';
COMMENT ON COLUMN "public".mch_merchant.login_pwd IS '登录密码';
COMMENT ON COLUMN "public".mch_merchant.name IS '名称';
COMMENT ON COLUMN "public".mch_merchant.company_name IS '公司名称';
COMMENT ON COLUMN "public".mch_merchant.self_sales IS '是否自营';
COMMENT ON COLUMN "public".mch_merchant.level IS '商户等级';
COMMENT ON COLUMN "public".mch_merchant.logo IS '标志';
COMMENT ON COLUMN "public".mch_merchant.province IS '省';
COMMENT ON COLUMN "public".mch_merchant.city IS '市';
COMMENT ON COLUMN "public".mch_merchant.district IS '区';
COMMENT ON COLUMN "public".mch_merchant.create_time IS '创建时间';
COMMENT ON COLUMN "public".mch_merchant.flag IS '标志';
COMMENT ON COLUMN "public".mch_merchant.enabled IS '是否启用';
COMMENT ON COLUMN "public".mch_merchant.expires_time IS '过期时间';
COMMENT ON COLUMN "public".mch_merchant.update_time IS '更新时间';
COMMENT ON COLUMN "public".mch_merchant.login_time IS '登录时间';
COMMENT ON COLUMN "public".mch_merchant.last_login_time IS '最后登录时间';


ALTER TABLE "public".mch_online_shop
    ADD COLUMN flag int4 NOT NULL;
COMMENT ON COLUMN "public".mch_online_shop.id IS '店铺编号';
COMMENT ON COLUMN "public".mch_online_shop.vendor_id IS '商户编号';
COMMENT ON COLUMN "public".mch_online_shop.shop_name IS '店铺名称';
COMMENT ON COLUMN "public".mch_online_shop.logo IS '店铺标志';
COMMENT ON COLUMN "public".mch_online_shop.host IS '自定义 域名';
COMMENT ON COLUMN "public".mch_online_shop.alias IS '个性化域名';
COMMENT ON COLUMN "public".mch_online_shop.tel IS '电话';
COMMENT ON COLUMN "public".mch_online_shop.addr IS '地址';
COMMENT ON COLUMN "public".mch_online_shop.shop_title IS '店铺标题';
COMMENT ON COLUMN "public".mch_online_shop.shop_notice IS '店铺公告';
COMMENT ON COLUMN "public".mch_online_shop.flag IS '标志';
COMMENT ON COLUMN "public".mch_online_shop.state IS '状态';
COMMENT ON COLUMN "public".mch_online_shop.create_time IS '创建时间';

/** 2019-11-15 */
ALTER TABLE "public".pro_category
    RENAME pro_model TO prod_model;
ALTER TABLE "public".pro_category
    alter column priority set not null;
COMMENT ON TABLE "public".pro_category IS '产品分类';
COMMENT ON COLUMN "public".pro_category.id IS '编号';
COMMENT ON COLUMN "public".pro_category.parent_id IS '上级分类';
COMMENT ON COLUMN "public".pro_category.prod_model IS '产品模型';
COMMENT ON COLUMN "public".pro_category.priority IS '优先级';
COMMENT ON COLUMN "public".pro_category.name IS '分类名称';
COMMENT ON COLUMN "public".pro_category.virtual_cat IS '是否为虚拟分类';
COMMENT ON COLUMN "public".pro_category.cat_url IS '分类链接地址';
COMMENT ON COLUMN "public".pro_category.icon IS '图标';
COMMENT ON COLUMN "public".pro_category.icon_xy IS '图标坐标';
COMMENT ON COLUMN "public".pro_category.level IS '分类层级';
COMMENT ON COLUMN "public".pro_category.sort_num IS '序号';
COMMENT ON COLUMN "public".pro_category.floor_show IS '是否楼层显示';
COMMENT ON COLUMN "public".pro_category.enabled IS '是否启用';
COMMENT ON COLUMN "public".pro_category.create_time IS '创建时间';

ALTER TABLE public.pro_category
    RENAME TO prod_category;

ALTER TABLE public.prod_category
    ALTER COLUMN enabled TYPE int4 USING enabled::int;

/** 2019-11-16 */
DROP TABLE express_template;
CREATE TABLE "public".mch_express_template (
   id         serial NOT NULL,
   vendor_id  int4 NOT NULL,
   name       varchar(45) NOT NULL,
   is_free    int2 NOT NULL,
   basis      int4 NOT NULL,
   first_unit int4 NOT NULL,
   first_fee  numeric(6, 2) NOT NULL,
   add_unit   int4 NOT NULL,
   add_fee    numeric(6, 2) NOT NULL,
   enabled    int2 NOT NULL,
   CONSTRAINT mch_express_template_pkey
       PRIMARY KEY (id));
COMMENT ON TABLE "public".mch_express_template IS '商户运费模板';
COMMENT ON COLUMN "public".mch_express_template.id IS '编号';
COMMENT ON COLUMN "public".mch_express_template.vendor_id IS '运营商编号';
COMMENT ON COLUMN "public".mch_express_template.name IS '运费模板名称';
COMMENT ON COLUMN "public".mch_express_template.is_free IS '是否卖价承担运费';
COMMENT ON COLUMN "public".mch_express_template.basis IS '运费计价依据';
COMMENT ON COLUMN "public".mch_express_template.first_unit IS '首次计价单位,如首重为2kg';
COMMENT ON COLUMN "public".mch_express_template.first_fee IS '首次计价单价,如续重1kg';
COMMENT ON COLUMN "public".mch_express_template.add_unit IS '超过首次计价计算单位,如续重1kg';
COMMENT ON COLUMN "public".mch_express_template.add_fee IS '超过首次计价单价，如续重1kg';
COMMENT ON COLUMN "public".mch_express_template.enabled IS '是否启用';


/** 2019-11-26 */
ALTER TABLE public.ad_list ALTER COLUMN type_id TYPE int4 USING type_id::integer;

/** 2019-12-13 */
UPDATE  "public".pro_product  set sale_price = 0 WHERE sale_price IS NULL;
UPDATE  "public".pro_product  set shelve_state = true WHERE shelve_state IS NULL;
UPDATE  "public".pro_product  set review_state = true WHERE review_state IS NULL;

ALTER TABLE "public".pro_product
  alter column cat_id set not null;
ALTER TABLE "public".pro_product
  alter column supplier_id set not null;
ALTER TABLE "public".pro_product
  alter column brand_id set not null;
ALTER TABLE "public".pro_product
  alter column name set not null;
ALTER TABLE "public".pro_product
  alter column code set not null;
ALTER TABLE "public".pro_product
  alter column img set not null;
ALTER TABLE "public".pro_product
  alter column sale_price set not null;
ALTER TABLE "public".pro_product
  alter column shelve_state TYPE int4 USING shelve_state::integer;
  ALTER TABLE "public".pro_product
  alter column shelve_state  set not null;
ALTER TABLE "public".pro_product
  alter column review_state TYPE int4 USING review_state::integer;
ALTER TABLE "public".pro_product
  alter column review_state set not null;
ALTER TABLE "public".pro_product
  alter column sort_num set not null;
ALTER TABLE "public".pro_product
  alter column description set not null;
ALTER TABLE "public".pro_product
  alter column state set not null;
ALTER TABLE "public".pro_product
  alter column remark set not null;
ALTER TABLE "public".pro_product
  alter column create_time set not null;
ALTER TABLE "public".pro_product
  alter column update_time set not null;
COMMENT ON TABLE "public".pro_product IS '产品';
COMMENT ON COLUMN "public".pro_product.id IS '编号';
COMMENT ON COLUMN "public".pro_product.cat_id IS '分类编号';
COMMENT ON COLUMN "public".pro_product.supplier_id IS '供货商编号';
COMMENT ON COLUMN "public".pro_product.brand_id IS '品牌编号';
COMMENT ON COLUMN "public".pro_product.name IS '名称';
COMMENT ON COLUMN "public".pro_product.code IS '产品编码';
COMMENT ON COLUMN "public".pro_product.img IS '产品图片';
COMMENT ON COLUMN "public".pro_product.sale_price IS '销售价格';
COMMENT ON COLUMN "public".pro_product.shelve_state IS '上架状态';
COMMENT ON COLUMN "public".pro_product.review_state IS '审核状态';
COMMENT ON COLUMN "public".pro_product.sort_num IS '排序编号';
COMMENT ON COLUMN "public".pro_product.description IS '描述';
COMMENT ON COLUMN "public".pro_product.state IS '产品状态';
COMMENT ON COLUMN "public".pro_product.remark IS '备注';
COMMENT ON COLUMN "public".pro_product.create_time IS '创建时间';
COMMENT ON COLUMN "public".pro_product.update_time IS '更新时间';


COMMENT ON TABLE "public".prod_category IS '产品分类';
COMMENT ON COLUMN "public".prod_category.id IS '编号';
COMMENT ON COLUMN "public".prod_category.parent_id IS '上级分类';
COMMENT ON COLUMN "public".prod_category.prod_model IS '产品模型';
COMMENT ON COLUMN "public".prod_category.priority IS '优先级';
COMMENT ON COLUMN "public".prod_category.name IS '分类名称';
COMMENT ON COLUMN "public".prod_category.virtual_cat IS '是否为虚拟分类';
COMMENT ON COLUMN "public".prod_category.cat_url IS '分类链接地址';
COMMENT ON COLUMN "public".prod_category.icon IS '图标';
COMMENT ON COLUMN "public".prod_category.icon_xy IS '图标坐标';
COMMENT ON COLUMN "public".prod_category.level IS '分类层级';
COMMENT ON COLUMN "public".prod_category.sort_num IS '序号';
COMMENT ON COLUMN "public".prod_category.floor_show IS '是否楼层显示';
COMMENT ON COLUMN "public".prod_category.enabled IS '是否启用';
COMMENT ON COLUMN "public".prod_category.create_time IS '创建时间';


ALTER TABLE "public".pro_brand
  alter column site_url set not null;
ALTER TABLE "public".pro_brand
  alter column intro set not null;
ALTER TABLE "public".pro_brand
  ADD COLUMN review_state int4 NOT NULL DEFAULT 0;
ALTER TABLE "public".pro_brand
  DROP COLUMN review;
ALTER TABLE "public".pro_brand
  alter column create_time set not null;
COMMENT ON TABLE "public".pro_brand IS '品牌';
COMMENT ON COLUMN "public".pro_brand.id IS '编号';
COMMENT ON COLUMN "public".pro_brand.name IS '品牌名称';
COMMENT ON COLUMN "public".pro_brand.image IS '品牌图片';
COMMENT ON COLUMN "public".pro_brand.site_url IS '品牌官网';
COMMENT ON COLUMN "public".pro_brand.intro IS '品牌介绍';
COMMENT ON COLUMN "public".pro_brand.review_state IS '审核';
COMMENT ON COLUMN "public".pro_brand.create_time IS '创建时间';


COMMENT ON TABLE "public".pro_attr_info IS '产品属性信息';
COMMENT ON COLUMN "public".pro_attr_info.id IS '编号';
COMMENT ON COLUMN "public".pro_attr_info.product_id IS '产品编号';
COMMENT ON COLUMN "public".pro_attr_info.attr_id IS '属性编号';
COMMENT ON COLUMN "public".pro_attr_info.attr_data IS '属性数据';
COMMENT ON COLUMN "public".pro_attr_info.attr_word IS '属性文本';


ALTER TABLE "public".pro_model
    alter column attr_str set not null;
ALTER TABLE "public".pro_model
    alter column spec_str set not null;
COMMENT ON TABLE "public".pro_model IS '产品模型';
COMMENT ON COLUMN "public".pro_model.id IS '编号';
COMMENT ON COLUMN "public".pro_model.name IS '模型名称';
COMMENT ON COLUMN "public".pro_model.attr_str IS '属性值';
COMMENT ON COLUMN "public".pro_model.spec_str IS '规格值';
COMMENT ON COLUMN "public".pro_model.enabled IS '是否启用';

ALTER TABLE "public".pro_attr
    alter column item_values set not null;
COMMENT ON TABLE "public".pro_attr IS '模型商品属性';
COMMENT ON COLUMN "public".pro_attr.id IS '编号';
COMMENT ON COLUMN "public".pro_attr.pro_model IS '商品模型';
COMMENT ON COLUMN "public".pro_attr.name IS '属性名称';
COMMENT ON COLUMN "public".pro_attr.is_filter IS '是否作为筛选条件';
COMMENT ON COLUMN "public".pro_attr.multi_chk IS '是否多选';
COMMENT ON COLUMN "public".pro_attr.item_values IS '属性项值';
COMMENT ON COLUMN "public".pro_attr.sort_num IS '排列序号';

COMMENT ON TABLE "public".pro_attr_item IS '商品模型属性项';
COMMENT ON COLUMN "public".pro_attr_item.id IS '编号';
COMMENT ON COLUMN "public".pro_attr_item.attr_id IS '属性编号';
COMMENT ON COLUMN "public".pro_attr_item.pro_model IS '商品模型';
COMMENT ON COLUMN "public".pro_attr_item.value IS '属性值';
COMMENT ON COLUMN "public".pro_attr_item.sort_num IS '排列序号';


ALTER TABLE "public".pro_spec
    alter column item_values set not null;
COMMENT ON TABLE "public".pro_spec IS '商品模型规格';
COMMENT ON COLUMN "public".pro_spec.id IS '编号';
COMMENT ON COLUMN "public".pro_spec.pro_model IS '商品模型';
COMMENT ON COLUMN "public".pro_spec.name IS '规格名称';
COMMENT ON COLUMN "public".pro_spec.item_values IS '规格项值';
COMMENT ON COLUMN "public".pro_spec.sort_num IS '排列序号';

COMMENT ON TABLE "public".pro_spec_item IS '产品模型规格项';
COMMENT ON COLUMN "public".pro_spec_item.id IS '编号';
COMMENT ON COLUMN "public".pro_spec_item.spec_id IS '规格编号';
COMMENT ON COLUMN "public".pro_spec_item.pro_model IS '商品模型';
COMMENT ON COLUMN "public".pro_spec_item.value IS '规格值';
COMMENT ON COLUMN "public".pro_spec_item.color IS '规格颜色';
COMMENT ON COLUMN "public".pro_spec_item.sort_num IS '排列序号';

COMMENT ON TABLE "public".pro_model_brand IS '商品模型关联品牌';
COMMENT ON COLUMN "public".pro_model_brand.id IS '编号';
COMMENT ON COLUMN "public".pro_model_brand.brand_id IS '品牌编号';
COMMENT ON COLUMN "public".pro_model_brand.pro_model IS '商品模型';

ALTER TABLE pro_product DROP COLUMN sale_price;
ALTER TABLE pro_product DROP COLUMN shelve_state;
ALTER TABLE pro_product DROP COLUMN review_state;

ALTER TABLE public.pro_product RENAME TO product;
ALTER TABLE public.pro_model RENAME TO product_model;
ALTER TABLE public.pro_brand RENAME TO product_brand;
ALTER TABLE public.pro_spec RENAME TO product_model_spec;
ALTER TABLE public.pro_spec_item RENAME TO product_model_spec_item;
ALTER TABLE public.pro_attr RENAME TO product_model_attr;
ALTER TABLE public.pro_attr_item RENAME TO product_model_attr_item;
ALTER TABLE public.pro_model_brand RENAME TO product_model_brand;
ALTER TABLE public.pro_attr_info RENAME TO product_attr_info;
ALTER TABLE public.prod_category RENAME TO product_category;


/* 2019-12-16 */
DROP TABLE mm_favorite;

CREATE TABLE "public".mm_favorite (
  id          serial NOT NULL,
  member_id   int4 NOT NULL,
  fav_type    int4 NOT NULL,
  refer_id    int4 NOT NULL,
  create_time int8 NOT NULL,
  CONSTRAINT mm_favorite_pkey
      PRIMARY KEY (id));
COMMENT ON TABLE "public".mm_favorite IS '会员收藏';
COMMENT ON COLUMN "public".mm_favorite.id IS '编号';
COMMENT ON COLUMN "public".mm_favorite.member_id IS '会员编号';
COMMENT ON COLUMN "public".mm_favorite.fav_type IS '收藏类型';
COMMENT ON COLUMN "public".mm_favorite.refer_id IS '关联编号';
COMMENT ON COLUMN "public".mm_favorite.create_time IS '收藏时间';

/** 2019-12-28 */
ALTER TABLE "public".mm_deliver_addr
  alter column member_id set not null;
ALTER TABLE "public".mm_deliver_addr
    RENAME COLUMN real_name to consignee_name;
ALTER TABLE "public".mm_deliver_addr
  ALTER COLUMN consignee_name set NOT NULL;
ALTER TABLE "public".mm_deliver_addr
    RENAME COLUMN phone to consignee_phone;
ALTER TABLE "public".mm_deliver_addr
    RENAME COLUMN address to detail_address;
ALTER TABLE "public".mm_deliver_addr
  ALTER COLUMN consignee_phone set NOT NULL;
ALTER TABLE "public".mm_deliver_addr
  alter column province set not null;
ALTER TABLE "public".mm_deliver_addr
  alter column city set not null;
ALTER TABLE "public".mm_deliver_addr
  alter column district set not null;
ALTER TABLE "public".mm_deliver_addr
  alter column area set not null;
ALTER TABLE "public".mm_deliver_addr
  alter COLUMN detail_address set NOT NULL;
ALTER TABLE "public".mm_deliver_addr
  alter column is_default set not null;
COMMENT ON TABLE "public".mm_deliver_addr IS '会员收货地址';
COMMENT ON COLUMN "public".mm_deliver_addr.id IS '编号';
COMMENT ON COLUMN "public".mm_deliver_addr.member_id IS '会员编号';
COMMENT ON COLUMN "public".mm_deliver_addr.consignee_name IS '收货人姓名';
COMMENT ON COLUMN "public".mm_deliver_addr.consignee_phone IS '收货人电话';
COMMENT ON COLUMN "public".mm_deliver_addr.province IS '数字编码(省)';
