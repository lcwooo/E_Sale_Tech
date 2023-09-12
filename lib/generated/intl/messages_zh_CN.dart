// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static m0(name) => "欢迎 ${name}";

  static m1(gender) => "{gender, select, male {Hi man!} 女生 {Hi woman!} other {Hi there!}}";

  static m2(role) => "{role, select, admin {Hi admin!} 管理 {Hi manager!} 其他 {Hi visitor!}}";

  static m3(howMany) => "{howMany, plural, one{1 message} 其他{${howMany} 消息}}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "SelectAll" : MessageLookupByLibrary.simpleMessage("全选"),
    "accountLogin" : MessageLookupByLibrary.simpleMessage("账号密码登录"),
    "addressInfo" : MessageLookupByLibrary.simpleMessage("地址详情"),
    "availableStock" : MessageLookupByLibrary.simpleMessage("当前可用库存："),
    "averagePrice" : MessageLookupByLibrary.simpleMessage("实时平均售价"),
    "backLogin" : MessageLookupByLibrary.simpleMessage("返回登录"),
    "cancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "chinese" : MessageLookupByLibrary.simpleMessage("中文简体"),
    "clear" : MessageLookupByLibrary.simpleMessage("清除"),
    "clickSend" : MessageLookupByLibrary.simpleMessage("点击发送"),
    "close" : MessageLookupByLibrary.simpleMessage("当前状态:关闭"),
    "country" : MessageLookupByLibrary.simpleMessage("国家"),
    "dataStatistics" : MessageLookupByLibrary.simpleMessage("数据统计"),
    "delete" : MessageLookupByLibrary.simpleMessage("删除"),
    "discount" : MessageLookupByLibrary.simpleMessage("优惠券"),
    "discountStores" : MessageLookupByLibrary.simpleMessage("店铺优惠"),
    "distribution" : MessageLookupByLibrary.simpleMessage("配送："),
    "downShelves" : MessageLookupByLibrary.simpleMessage("下架"),
    "editPrice" : MessageLookupByLibrary.simpleMessage("编辑价格"),
    "email" : MessageLookupByLibrary.simpleMessage("邮箱"),
    "enable" : MessageLookupByLibrary.simpleMessage("当前状态:开启"),
    "english" : MessageLookupByLibrary.simpleMessage("英语"),
    "enterPriFit" : MessageLookupByLibrary.simpleMessage("请输入利润"),
    "favorites" : MessageLookupByLibrary.simpleMessage("收藏夹"),
    "forgetPassword" : MessageLookupByLibrary.simpleMessage("忘记密码"),
    "goodDetail" : MessageLookupByLibrary.simpleMessage("商品详情"),
    "goods" : MessageLookupByLibrary.simpleMessage("商品"),
    "goodsDescription" : MessageLookupByLibrary.simpleMessage("商品描述"),
    "goodsDetails" : MessageLookupByLibrary.simpleMessage("商品详情"),
    "goodsOrigin" : MessageLookupByLibrary.simpleMessage("商品产地 ："),
    "goodsSpecifications" : MessageLookupByLibrary.simpleMessage("商品规格"),
    "historySearch" : MessageLookupByLibrary.simpleMessage("历史搜索"),
    "homeSearchHint" : MessageLookupByLibrary.simpleMessage("搜索商品或品牌"),
    "inputPriec" : MessageLookupByLibrary.simpleMessage("请输入价格"),
    "instructions" : MessageLookupByLibrary.simpleMessage("说明："),
    "inventory" : MessageLookupByLibrary.simpleMessage("库存"),
    "language" : MessageLookupByLibrary.simpleMessage("语言"),
    "login" : MessageLookupByLibrary.simpleMessage("登录"),
    "loginSuccessful" : MessageLookupByLibrary.simpleMessage("登录成功"),
    "lowestPrice" : MessageLookupByLibrary.simpleMessage("最低售价"),
    "mobileQuickLogin" : MessageLookupByLibrary.simpleMessage("手机快捷登录"),
    "mustKnow" : MessageLookupByLibrary.simpleMessage("购买须知"),
    "myGoods" : MessageLookupByLibrary.simpleMessage("我的商品"),
    "myProperty" : MessageLookupByLibrary.simpleMessage("我的资产"),
    "name" : MessageLookupByLibrary.simpleMessage("名"),
    "netContent" : MessageLookupByLibrary.simpleMessage("单位净含量 ："),
    "netProfit" : MessageLookupByLibrary.simpleMessage("按照利润净值"),
    "newPassword" : MessageLookupByLibrary.simpleMessage("新密码"),
    "number" : MessageLookupByLibrary.simpleMessage("数量"),
    "offShelves" : MessageLookupByLibrary.simpleMessage("下架商品"),
    "orderManagement" : MessageLookupByLibrary.simpleMessage("订单管理"),
    "ordersForCustomers" : MessageLookupByLibrary.simpleMessage("客户下单"),
    "originPrice" : MessageLookupByLibrary.simpleMessage("原价"),
    "owerPays" : MessageLookupByLibrary.simpleMessage("店主下单"),
    "pageHomeConfirm" : MessageLookupByLibrary.simpleMessage("确认"),
    "pageHomeWelcome" : m0,
    "pageHomeWelcomeGender" : m1,
    "pageHomeWelcomeRole" : m2,
    "pageNotificationsCount" : m3,
    "password" : MessageLookupByLibrary.simpleMessage("密码"),
    "passwordConfirmation" : MessageLookupByLibrary.simpleMessage("密码确认"),
    "passwordsAreInconsistent" : MessageLookupByLibrary.simpleMessage("输入的密码不一致"),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("手机号"),
    "placeTheOrder" : MessageLookupByLibrary.simpleMessage("立即下单"),
    "pleaseInputAddress" : MessageLookupByLibrary.simpleMessage("请填写地址"),
    "pleaseInputEmail" : MessageLookupByLibrary.simpleMessage("请填写邮箱"),
    "pleaseInputMobileNumber" : MessageLookupByLibrary.simpleMessage("请填写手机号/邮箱"),
    "pleaseInputName" : MessageLookupByLibrary.simpleMessage("请填写姓名"),
    "pleaseInputPassword" : MessageLookupByLibrary.simpleMessage("请输入密码"),
    "pleaseSelectCountry" : MessageLookupByLibrary.simpleMessage("请选择国家"),
    "priFitForpercentage" : MessageLookupByLibrary.simpleMessage("按照利润比例"),
    "profit" : MessageLookupByLibrary.simpleMessage("收益"),
    "quickLogin" : MessageLookupByLibrary.simpleMessage("快捷登录"),
    "readAgree" : MessageLookupByLibrary.simpleMessage("我已阅读并同意"),
    "register" : MessageLookupByLibrary.simpleMessage("注册"),
    "resend" : MessageLookupByLibrary.simpleMessage("重新发送"),
    "resetPassword" : MessageLookupByLibrary.simpleMessage("重置密码"),
    "salePrice" : MessageLookupByLibrary.simpleMessage("售卖价"),
    "saleprice1" : MessageLookupByLibrary.simpleMessage("售卖价 ￥"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "search" : MessageLookupByLibrary.simpleMessage("搜索"),
    "searchPageSearchHint" : MessageLookupByLibrary.simpleMessage("搜索品牌、类目、商品名"),
    "serviceAgreement" : MessageLookupByLibrary.simpleMessage("《服务协议》"),
    "setTips" : MessageLookupByLibrary.simpleMessage("请先设置商品利润"),
    "shareStore" : MessageLookupByLibrary.simpleMessage("分享店铺"),
    "shopDesign" : MessageLookupByLibrary.simpleMessage("店铺设计"),
    "submit" : MessageLookupByLibrary.simpleMessage("提交"),
    "sure" : MessageLookupByLibrary.simpleMessage("确定"),
    "surname" : MessageLookupByLibrary.simpleMessage("姓"),
    "thirdPartyLogin" : MessageLookupByLibrary.simpleMessage("第三方登录"),
    "topSearch" : MessageLookupByLibrary.simpleMessage("热门搜索"),
    "uniformlySetProfit" : MessageLookupByLibrary.simpleMessage("统一设置利润"),
    "upShelves" : MessageLookupByLibrary.simpleMessage("上架商品"),
    "userAgreement" : MessageLookupByLibrary.simpleMessage("请勾选用户协议"),
    "verification" : MessageLookupByLibrary.simpleMessage("验证码"),
    "verificationCode" : MessageLookupByLibrary.simpleMessage("请输入验证码"),
    "visitor" : MessageLookupByLibrary.simpleMessage("访客"),
    "warmTips" : MessageLookupByLibrary.simpleMessage("若售卖价低于最低售价，将取最低售价")
  };
}
