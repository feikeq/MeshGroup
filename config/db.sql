-- 用户API接口数据库设计
-- DB架构师：肥客泉 FK68.net
-- 创造时间：2012-04-17
-- 修改时间：2023-07-10


-- --------------------------------------------------------
-- (系统表)用户中心表 `sys_user`
-- --------------------------------------------------------
-- uid 用户ID16位(1552276542005575) = 毫秒时间戳13位(1552276542005) + 3位随机数(001)
-- ciphers 密码 = MD5(注册时间格式字符串+MD5(明文密码串))
-- intime 注册时间 为手动填入且注册时间不能变否则密码核对失败
-- object 预留字段 因是TEXT类型不能设置缺省值所以入库时尽量初始化为空字符串减少程序错误
CREATE TABLE IF NOT EXISTS `sys_user` (
    `uid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID(自动)',
    `username` varchar(32) NOT NULL DEFAULT '' COMMENT '帐号(开放平台末绑定自动添加openid)',
    `ciphers` char(32) NOT NULL DEFAULT '' COMMENT '密码(为空则是开放台的没有绑定)',
    `email` varchar(128) NOT NULL DEFAULT '' COMMENT '邮箱(也可做登录名)',
    `cell` varchar(128) NOT NULL DEFAULT '' COMMENT '电话(也可做登录名)',
    `nickname` varchar(128) NOT NULL DEFAULT '' COMMENT '昵称',
    `headimg` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
    `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别(0未知 1男 2女)',
    `birthday` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '出生日期',
    `company` varchar(100) NOT NULL DEFAULT '' COMMENT '公司',
    `address` varchar(100) NOT NULL DEFAULT '' COMMENT '地址',
    `city` varchar(50) NOT NULL DEFAULT '' COMMENT '城市',
    `province` varchar(50) NOT NULL DEFAULT '' COMMENT '省份',
    `country` varchar(50) NOT NULL DEFAULT '' COMMENT '国家',
    `regip` varchar(128) NOT NULL DEFAULT '0.0.0.0' COMMENT '注册IP地址',
    `referer` varchar(50) NOT NULL DEFAULT '' COMMENT '用户来源',
    `inviter` bigint unsigned NOT NULL DEFAULT '0' COMMENT '邀请者UID',
    `userclan` varchar(128) NOT NULL DEFAULT '' COMMENT '用户拓谱图(以逗号分隔)',
    `fname` varchar(50) NOT NULL DEFAULT '' COMMENT '真实姓名',
    `bankcard` varchar(50) NOT NULL DEFAULT '' COMMENT '银行卡',
    `identity_card` varchar(50) NOT NULL DEFAULT '' COMMENT '身份证(也可做登录名)',
    `grouptag` varchar(128) NOT NULL DEFAULT '' COMMENT '用户组',
    `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
    `object` text COMMENT '预留字段(不检索,可存json数组)',
    `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态(0停用 1正常 2待激活)',
    `intime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '注册时间',
    `uptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间',
    PRIMARY KEY (`uid`),
    UNIQUE KEY `username` (`username`),
    KEY `identity_card` (`identity_card`),
    KEY `email` (`email`),
    KEY `cell` (`cell`),
    KEY `grouptag` (`grouptag`),
    KEY `referer` (`referer`),
    KEY `inviter` (`inviter`),
    KEY `remark` (`remark`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户中心表';

-- --------------------------------------------------------
-- (系统表)开放平台用户表 `sys_oauth`
-- --------------------------------------------------------
-- unionid 不一定有所以不能用作唯一索引，优先判断openid不存在再去判断unionid
-- privilege 用户特权信息 因是TEXT类型不能设置缺省值所以入库时尽量初始化为空字符串减少程序错误
-- tidings 用户动态 因是TEXT类型不能设置缺省值所以入库时尽量初始化为空字符串减少程序错误
-- object 预留字段 因是TEXT类型不能设置缺省值所以入库时尽量初始化为空字符串减少程序错误
CREATE TABLE IF NOT EXISTS `sys_oauth` (
  `oid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '序号(自动)',
  `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '用户ID(同一平台只能绑定一个用户ID)',
  `platfrom` varchar(50) NOT NULL DEFAULT '' COMMENT '外接平台名(微信、支付宝、AppID..)',
  `openid` varchar(128) BINARY NOT NULL DEFAULT '' COMMENT '外接平台身份ID(区分大小写)',
  `headimg` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `unionid` varchar(128) NOT NULL DEFAULT '' COMMENT '外接唯一标识[英文帐号]',
  `nickname` varchar(128) NOT NULL DEFAULT '' COMMENT '昵称',
  `sex` char(1) NOT NULL DEFAULT '0' COMMENT '性别(0未知 1男 2女)',
  `city` varchar(50) NOT NULL DEFAULT '' COMMENT '城市',
  `province` varchar(50) NOT NULL DEFAULT '' COMMENT '省份',
  `country` varchar(50) NOT NULL DEFAULT '' COMMENT '国家',
  `language` varchar(50) NOT NULL DEFAULT '' COMMENT '语言(zh_CN、EN)',
  `privilege` text COMMENT '用户特权信息(json数组)[关注数粉丝数等]',
  `token` varchar(128) DEFAULT '' COMMENT '平台接口授权凭证',
  `expires` varchar(128) NOT NULL DEFAULT '' COMMENT '平台授权失效时间',
  `refresh` varchar(128) NOT NULL DEFAULT '' COMMENT '平台刷新token',
  `scope` varchar(255) NOT NULL DEFAULT '' COMMENT '用户授权的作用域(使用逗号分隔)',
  `subscribe` int NOT NULL DEFAULT '0' COMMENT '是否关注[或是follow数]',
  `subscribetime` varchar(128) NOT NULL DEFAULT '' COMMENT '关注时间(时间戳)',
  `grouptag` varchar(128) NOT NULL DEFAULT '' COMMENT '分组',
  `tidings` text COMMENT '用户动态(json数组)[或最近一条社交信息]',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注(是否认证)',
  `object` text COMMENT '预留字段(不检索,可存json数组)',
  `intime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入库时间(自动)',
  `uptime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间(自动)',
  PRIMARY KEY (`oid`),
  UNIQUE KEY `platfrom_openid` (`platfrom`,`openid`),
  KEY `uid` (`uid`),
  KEY `platfrom` (`platfrom`),
  KEY `openid` (`openid`),
  KEY `unionid` (`unionid`),
  KEY `subscribetime` (`subscribetime`),
  KEY `subscribe` (`subscribe`),
  KEY `remark` (`remark`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开放平台用户表';

-- --------------------------------------------------------
-- (系统表)用户附属资料表 `sys_material`
-- --------------------------------------------------------
-- 存放经常变动的数据，与表用户中心是一对一关系，可以自由添加其他字段
-- object 预留字段 因是TEXT类型不能设置缺省值所以入库时尽量初始化为空字符串减少程序错误
CREATE TABLE IF NOT EXISTS `sys_material` (
  `uid` bigint unsigned NOT NULL COMMENT '用户UID',
  `cid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '联系人ID',
  `balance` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '余额（元）',
  `vip` char(1) NOT NULL DEFAULT '0' COMMENT '会员(0否 1是 2超级会员)',
  `exptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '会员到期时间',
  `manage` char(1) NOT NULL DEFAULT '0' COMMENT '管理权限(0普通用户 1管理员)',
  `tag` varchar(128) NOT NULL DEFAULT '' COMMENT '权限标识',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `object` text COMMENT '预留字段(不检索,可存json数组)',
  `intime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入库时间(自动)',
  `uptime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间(自动)',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid_cid` (`uid`,`cid`),
  KEY `balance` (`balance`),
  KEY `vip` (`vip`),
  KEY `exptime` (`exptime`),
  KEY `intime` (`intime`),
  KEY `manage` (`manage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户附属资料表';

-- --------------------------------------------------------
-- (系统表)用户日志表 `sys_logs`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sys_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作标识(login,pay,sys)',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '操作说明(微信登录、修改密码、充值等)',
  `actip` varchar(128) NOT NULL DEFAULT '' COMMENT '操作IP地址',
  `ua` varchar(255) NOT NULL DEFAULT '' COMMENT '设备信息',
  `intime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `action` (`action`),
  KEY `intime` (`intime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户日志表';


















-- --------------------------------------------------------
-- (商城业务)店铺表 `store_merchant`
-- --------------------------------------------------------
-- mid 店铺ID  = “2” + 毫秒时间戳13位(1552276542005)
-- resellerrate 默认佣金比例 = 一级金额,二级金额,三级金额 (佣金总计不超销售金额50%才合法)

CREATE TABLE IF NOT EXISTS `store_merchant` (
    `mid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '店铺ID(自动)',
    `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
    `domain` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺网址',
    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺名',
    `name` varchar(255) NOT NULL DEFAULT '' COMMENT '商户全称',
    `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺图标',
    `object` text COMMENT 'banner轮播图(不检索,可存json数组)',
    `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
    `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态(0闭店 1营业 2审核中)',
    `reseller` tinyint NOT NULL DEFAULT '0' COMMENT '分销级别(0无分销 1一级分销 2二级分销 3三级分销)',
    `resellerrate` varchar(255) NOT NULL DEFAULT '20,10,5' COMMENT '缺省佣金比例',
    `intime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '注册时间',
    `uptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间',
    PRIMARY KEY (`mid`),
    UNIQUE KEY `domain` (`domain`),
    KEY `uid` (`uid`),
    KEY `title` (`title`),
    KEY `name` (`name`),
    KEY `state` (`state`),
    KEY `reseller` (`reseller`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='店铺表';




-- --------------------------------------------------------
-- (商城业务)商品表 `store_product`
-- --------------------------------------------------------
-- pid 商品ID  = “2” + 毫秒时间戳13位(1552276542005) + 4位随机数(0001)
-- poster 商品海报 = 轮播图或视频 json 格式，包含 video和image类型
-- parameter 当某一参数为多个时页面显示相信的诸如颜色和规格的选择
-- label 价签 = 显示活动价折扣价促销价拼团价报名预约等
-- 注意当有拼团订单正在进行中时不能修改商品信息

CREATE TABLE IF NOT EXISTS `store_product` (
    `pid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '商品ID(自动)',
    `mid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID',
    `type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品分类',
    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名',
    `image` varchar(255) NOT NULL DEFAULT '' COMMENT '商品图',
    `poster` text COMMENT '商品海报(轮播图或视频）',
    `description` text COMMENT '商品描述',
    `parameter` varchar(1024) NOT NULL DEFAULT '' COMMENT '商品参数(json格式当)',
    `hot` tinyint(1) NOT NULL DEFAULT '0' COMMENT '推荐商品(0普通 1推荐 2热卖)',
    `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
    `price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '售价(可免费)',
    `primed` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '原价',
    `label` varchar(32) NOT NULL DEFAULT '活动价' COMMENT '价签(拼团,报名,预约)',
    `capacity` tinyint NOT NULL DEFAULT '0' COMMENT '最大拼团人数',
    `achieve` tinyint NOT NULL DEFAULT '0' COMMENT '拼团成功人数',
    `deadline` int NOT NULL DEFAULT '0' COMMENT '拼团截止时间(分钟)',
    `stock` int NOT NULL DEFAULT '0' COMMENT '当前库存',
    `sales` int NOT NULL DEFAULT '0' COMMENT '总销量',
    `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态(0下架 1上架)',
    `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '操作人ID',
    `intime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
    `uptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间',
    PRIMARY KEY (`pid`),
    KEY `mid` (`mid`),
    KEY `type` (`type`),
    KEY `title` (`title`),
    KEY `hot` (`hot`),
    KEY `price` (`price`),
    KEY `primed` (`primed`),
    KEY `label` (`label`),
    KEY `capacity` (`capacity`),
    KEY `achieve` (`achieve`),
    KEY `stock` (`stock`),
    KEY `sales` (`sales`),
    KEY `state` (`state`),
    KEY `uid` (`uid`),
    KEY `uptime` (`uptime`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品表';



-- --------------------------------------------------------
-- (商城业务)订单表 `stroe_order`
-- --------------------------------------------------------
-- oid 订单表ID  = “2” + 毫秒时间戳13位(1552276542005) + 4位随机数(0001)
-- 自动冗余店铺信息、商品信息、买家信息
-- uptime 更新时间或预约时间

CREATE TABLE IF NOT EXISTS `stroe_order` (
    `oid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID(自动)',
    `mid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '商铺ID',
    `name` varchar(255) NOT NULL DEFAULT '' COMMENT '商户全称',
    `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺图标',
    `reseller` tinyint NOT NULL DEFAULT '0' COMMENT '店铺分销级别',
    `resellerrate` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺佣金比例',
    `pid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名',
    `image` varchar(255) NOT NULL DEFAULT '' COMMENT '商品图',
    `parameter` varchar(255) NOT NULL DEFAULT '' COMMENT '商品参数（数组）',
    `gid` int NOT NULL DEFAULT '0' COMMENT '拼团ID',
    `price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '成交价格',
    `quantity` int NOT NULL DEFAULT '1' COMMENT '下单数量',
    `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '买家ID',
    `nickname` varchar(128) NOT NULL DEFAULT '' COMMENT '昵称',
    `headimg` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
    `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别',
    `email` varchar(128) NOT NULL DEFAULT '' COMMENT '邮箱',
    `cell` varchar(128) NOT NULL DEFAULT '' COMMENT '电话',
    `fname` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
    `address` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
    `city` varchar(255) NOT NULL DEFAULT '' COMMENT '城市',
    `province` varchar(255) NOT NULL DEFAULT '' COMMENT '省份',
    `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '买家备注',
    `state` tinyint NOT NULL DEFAULT '1' COMMENT '订单状态(0待支付、1已支付、2拼单中、3已发货、4已完成、5已取消、6异常)',
    `logistics` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司',
    `waybill` varchar(255) NOT NULL DEFAULT '' COMMENT '快递单号',
    `intime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '下单时间',
    `uptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间或预约时间',
    PRIMARY KEY (`oid`),
    KEY `mid` (`mid`),
    KEY `pid` (`pid`),
    KEY `title` (`title`),
    KEY `gid` (`gid`),
    KEY `price` (`price`),
    KEY `uid` (`uid`),
    KEY `nickname` (`nickname`),
    KEY `city` (`city`),
    KEY `province` (`province`),
    KEY `state` (`state`),
    KEY `intime` (`intime`),
    KEY `uptime` (`uptime`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';





-- --------------------------------------------------------
-- (商城业务)拼团表 `store_group`
-- --------------------------------------------------------
-- gid 拼团ID  = “2” + 毫秒时间戳13位(1552276542005) + 4位随机数(0001)

CREATE TABLE IF NOT EXISTS `store_group` (
    `gid` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '拼团ID(自动)',
    `pid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '拼团商品ID',
    `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '团长ID',
    `capacity` int NOT NULL DEFAULT '0' COMMENT '最大拼团人数',
    `achieve` int NOT NULL DEFAULT '0' COMMENT '拼团成功人数',
    `evolve` int NOT NULL DEFAULT '1' COMMENT '当前进度',
    `deadline` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '拼团截止时间',
    `intime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '开团时间',
    `uptime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间',
    PRIMARY KEY (`gid`),
    KEY `pid` (`pid`),
    KEY `uid` (`uid`),
    KEY `evolve` (`evolve`),
    KEY `pid` (`pid`),
    KEY `intime` (`intime`),
    KEY `uptime` (`uptime`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='拼团表';








// 分销表
CREATE TABLE distribution (
  distribution_id INT PRIMARY KEY,
  item_id INT NOT NULL,
  distribution_level INT NOT NULL,
  distribution_commission DECIMAL(5,2) NOT NULL,
  FOREIGN KEY (item_id) REFERENCES item(item_id)
);




