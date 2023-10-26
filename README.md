# 合众拼销 - MeshGroup  Ver 3.1.0
[![The Go Programming Language](https://img.shields.io/badge/Go-v1.20.5-green)](https://github.com/golang/go)
[![Iris](https://img.shields.io/badge/Iris-v12.2.0-green)](https://github.com/kataras/iris)
[![sqlx](https://img.shields.io/badge/sqlx-v1.3.5-green)](https://github.com/jmoiron/sqlx)
[![lunar](https://img.shields.io/badge/lunar-v1.3.3-green)](https://github.com/6tail/lunar-go)
[![go-pinyin](https://img.shields.io/badge/go%20pinyin-v0.20.0-green)](https://github.com/mozillazg/go-pinyin)
[![Tencent Cloud SDK for Go](https://img.shields.io/badge/tencentcloud%20sdk%20go-v1.0.667-green)](https://github.com/tencentcloud/tencentcloud-sdk-go/)
[![Generator of unique non-sequential short Ids](https://img.shields.io/badge/shortid-v0.0.0-green)](https://github.com/teris-io/shortid)
[![go-vcard](https://img.shields.io/badge/go%20vcard-v0.3.0-green)](https://github.com/emersion/go-vcard)



![TiBiJ image](https://www.tibiji.com/web/images/logo.png)


肥客联邦官网：
[FK68.net](http://fk68.net)

作者：肥客泉 - [https://github.com/feikeq](https://github.com/feikeq)




## 🏆 一个全新的go项目：
1. 采用iris-go的MVC模式来更好地组织路由和控制器和模型的代码
2. 使用sqlx连接MySQL数据库并使用config/mysql.go文件单独管理
3. 并且拥有user等多个模块同时使用了控制器加模型的MVC设计模式 
4. 集成微信SDK和腾讯云短信也可采用smtp发送邮件通知
5. 集合农历库能对阴历生日进行有效计算
6. 集合中文拼音功能让检索数据更加方便
7. 支持手机通讯录vCard文件导入至联系人


## ⚙️ 项目配置
配置文件所在位置 config/cfg.ini
```
[Other] 
    SERV_ADDR = ":8888" # 端口
    SERV_NAME = "提笔记服务端" # 项目名
    SERV_EXPIRES_TIME = 172800  # 设置token的有效时间(秒) 2天  
    SERV_KEY_SECRET = "www.ccav.tv" # API高级密钥
    SERV_LIST_SIZE = 20 # 默认单页条数
    SERV_SAFE_GTIME = 30 # 获取密保超时时间(秒)。 30秒半分钟
    SERV_SAFE_ETIME = 1800 # 设置密保超时时间(秒)。 半小时
    SERV_NOTEPAD_MAX = 5 # 每个人最大云纸张(记事本)数量
```


## 💻 环境变量
TIBIJI_SERV_ENV 如果没有设置默认为正式生产环境，
你可以通过在终端或命令提示符中使用以下命令来设置环境变量：

Unix系统 
```bash
export TIBIJI_SERV_ENV=development
```
Windows系统 
```bat
set TIBIJI_SERV_ENV=development
```

## ✅ API基本数据结构
* code : 错误编码 （当它返回为0时则正常否则为异常）
* msg : 错误信息 （无错误时通常为空但也有正常情况下返回的）
* data : 数据对象 （字符、数字、数组、对像等）

```json
{
    "code":0,
    "msg":"",
    "data":null
}
```

## 🚀 启动服务
```sh
go run main.go
```

## 🛰 编译部署
不使用 go build 而使用名为build.sh的Shell脚本来进行编译
```sh
chmod +x build.sh
./build.sh
```


## 🐬 数据割接
```sql

-- 导入用户表
INSERT INTO myapp.sys_user (`uid`,`username`,`ciphers`,`email`,`cell`,`intime`,`uptime`,`regip`,`referer`,`state`,`object`)
SELECT `uid`,`username`,`password`,`email`,`cell`,`intime`,`uptime`,`regip`,`txt`,`status`,`notepad` FROM tibiji.tbj_user;

-- 导入用户附属资料表
INSERT INTO myapp.sys_material (`uid`,`cid`,`balance`,`object`,`remark`,`intime`,`uptime`)
SELECT `uid`,COALESCE(`cid`,0),`money`,`lastlog`,`allmoney`,`intime`,`uptime` FROM tibiji.tbj_user;

-- 导入用户最后一次登录日志
INSERT INTO myapp.sys_logs (`uid`,`action`,`note`,`actip`,`intime`)
SELECT `uid`, "login","username", SUBSTRING_INDEX(SUBSTRING_INDEX(lastlog,"||", 1),"::",1) AS "ip",SUBSTRING_INDEX(SUBSTRING_INDEX(lastlog,"||", 1),"::",-1) AS "time"  
FROM tibiji.tbj_user;


-- 导入开放平台用户表 (使用分割字符串为多行多条记录的方式)
INSERT INTO myapp.sys_oauth (`uid`,`platfrom`,`nickname`,`openid`,`intime`,`uptime`,`privilege`,`object`,`tidings`)
SELECT a.uid,SUBSTRING_INDEX(SUBSTRING_INDEX(a.otherid,'||',1),'::',1) as "type" ,a.username, SUBSTRING_INDEX(SUBSTRING_INDEX(a.otherid,'||',1),'::',-1) AS 'otherid', a.intime , a.uptime ,"","","" FROM tibiji.tbj_user a  WHERE otherid !=''
UNION SELECT b.uid,SUBSTRING_INDEX(SUBSTRING_INDEX(b.otherid,'||',2),'::',1) as "type" , b.username, SUBSTRING_INDEX(SUBSTRING_INDEX(b.otherid,'||',2),'::',-1) AS 'otherid', b.intime ,b.uptime,"","","" FROM tibiji.tbj_user b  WHERE b.otherid !='';


-- 导入用户联系人
INSERT INTO myapp.tbj_contact 
(`cid`,`uid`,`fullname`,`pinyin`,`nickname`,`picture`,`phone`,`mail`,`im`,`http`,`company`,`position`,`address`,`gender`,`birthday`,`lunar`,`grouptag`,`remind`,`relation`,`family`,`note`,`state`,`intime`,`uptime`)
SELECT `cid`,`uid`,`fname`,COALESCE(`pinyin`,''),COALESCE(`nickname`,''),COALESCE(`picture`,''),COALESCE(`phone`,''),COALESCE(`mail`,''),COALESCE(`im`,''),COALESCE(`http`,''),COALESCE(`company`,''),COALESCE(`position`,''),COALESCE(`address`,''),CASE `gender` WHEN '男' THEN 1 WHEN '女' THEN  2 ELSE 0 END  AS "tonum",COALESCE(`birthday`,'0000-00-00 00:00:00'),lunar,COALESCE(`group`,''),COALESCE(`remind`,''),COALESCE(`relation`,''),COALESCE(`family`,''),COALESCE(`note`,''),`status`,`intime`,`uptime`
FROM tibiji.tbj_contact;



-- 导入记帐表
INSERT INTO myapp.tbj_account (`uid`,`item`,`class`,`sort`,`cid`,`object`,`accounts`,`money`,`note`,`btime`,`intime`,`uptime`)
SELECT `uid`,`item`,`class`,`sort`,0,`object`,`accounts`,`money`,`note`,`intime`,`intime`,`intime` FROM tibiji.tbj_account;
-- 更新记帐表CID
UPDATE `myapp`.`tbj_account` a JOIN tibiji.tbj_contact b ON a.uid = b.uid AND a.object = b.fname   SET a.`cid` =  b.`cid` WHERE a.object !='';



-- 导入记事本表
INSERT INTO myapp.tbj_notepad (`nid`,`uid`,`url`,`share`,`content`,`pwd`,`state`,`caret`,`scroll`,`ip`,`referer`,`intime`,`uptime`)
SELECT `id`,0,`url`,`share`,`content`,`pwd`,`status`,`caret`,`scroll`,`ip`,`referer`,`intime`,`uptime` FROM tibiji.tbj_notepad;
-- 更新记事本CID
UPDATE myapp.tbj_notepad  SET `uid` = `referer` WHERE referer !='' AND referer  REGEXP '^[0-9]+$';


```

## 📄 文档地址
 [提笔记API接口文档接口文档](https://console-docs.apipost.cn/preview/24229f55dd876c3f/46b8e7c7322b8614)

 [提笔记API接口文档接口文档.html](./%E6%8F%90%E7%AC%94%E8%AE%B0API%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3.html)


## 🛡 安全漏洞

如果您发现在 TiBiJi 存在安全漏洞，请发送电子邮件至 [service@tibiji.com](mailto:service@tibiji.com)。所有安全漏洞将会得到及时解决。

## 📝 开源协议

就像其它开源项目的协议一样。
