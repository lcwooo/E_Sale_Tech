import 'package:E_Sale_Tech/model/goods/goodsDetailInfo.dart';
import 'package:E_Sale_Tech/model/index.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/views/goods/Order/order_Settlement.dart';
import 'package:E_Sale_Tech/views/goods/Order/pay_ment_page.dart';
import 'package:E_Sale_Tech/views/goods/edit_goods_price.dart';
import 'package:E_Sale_Tech/views/goods/goods.dart';
import 'package:E_Sale_Tech/views/home/TypeListPage.dart';
import 'package:E_Sale_Tech/views/home/allCategories.dart';
import 'package:E_Sale_Tech/views/home/categories_List.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_list.dart';
import 'package:E_Sale_Tech/views/me/my_address/edit_address.dart';
import 'package:E_Sale_Tech/views/me/my_customer_service/customer_service.dart';
import 'package:E_Sale_Tech/views/me/my_invoice/invoice_list.dart';
import 'package:E_Sale_Tech/views/me/my_msg/msg_detail.dart';
import 'package:E_Sale_Tech/views/me/my_msg/my_msg.dart';
import 'package:E_Sale_Tech/views/me/my_profile/complate_profile.dart';
import 'package:E_Sale_Tech/views/me/my_property/apply_withdraw.dart';
import 'package:E_Sale_Tech/views/me/my_property/my_property.dart';
import 'package:E_Sale_Tech/views/me/my_property/withdraw_record.dart';
import 'package:E_Sale_Tech/views/me/setting/about_us.dart';
import 'package:E_Sale_Tech/views/me/setting/change_pwd.dart';
import 'package:E_Sale_Tech/views/me/setting/setting.dart';
import 'package:E_Sale_Tech/views/goods/promote/promote_page.dart';
import 'package:E_Sale_Tech/views/goods/screening/screening_page.dart';
import 'package:E_Sale_Tech/views/shop/collection/batch_put_on_shelf.dart';
import 'package:E_Sale_Tech/views/shop/collection/collection.dart';
import 'package:E_Sale_Tech/views/shop/coupon/coupon_manager.dart';
import 'package:E_Sale_Tech/views/shop/coupon/preview_coupon.dart';
import 'package:E_Sale_Tech/views/shop/coupon/set_coupon.dart';
import 'package:E_Sale_Tech/views/shop/coupon/set_coupon_range.dart';
import 'package:E_Sale_Tech/views/shop/coupon/set_coupon_select_brand.dart';
import 'package:E_Sale_Tech/views/shop/coupon/set_coupon_select_category.dart';
import 'package:E_Sale_Tech/views/shop/coupon/set_coupon_select_goods.dart';
import 'package:E_Sale_Tech/views/shop/data_statistic/data_statistic.dart';
import 'package:E_Sale_Tech/views/shop/discount_stores/discount_stores.dart';
import 'package:E_Sale_Tech/views/shop/order_manager/order_manager.dart';
import 'package:E_Sale_Tech/views/shop/order_manager/order_manager_detail.dart';
import 'package:E_Sale_Tech/views/shop/order_manager/order_manager_logistics_detail.dart';

import 'package:E_Sale_Tech/views/goods/goods_detail_page.dart';
import 'package:E_Sale_Tech/views/home/real_name_authentication.dart';
import 'package:E_Sale_Tech/views/home/search_page.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/modify_shop_name.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/modify_shop_qr_code.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/modify_shop_signature.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_decoration.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_design.dart';
import 'package:E_Sale_Tech/views/home/fill_information.dart';
import 'package:E_Sale_Tech/views/home/open_shop.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_drag.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_template.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_template_goods_style.dart';
import 'package:E_Sale_Tech/views/shop/shop_design/shop_template_img_ad.dart';
import 'package:E_Sale_Tech/views/shop/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/not_found.dart';
import 'package:E_Sale_Tech/views/me/language.dart';
import 'package:E_Sale_Tech/views/login/mobile_login.dart';
import 'package:E_Sale_Tech/views/login/login.dart';
import 'package:E_Sale_Tech/views/login/reset_password.dart';
import 'package:E_Sale_Tech/views/login/user_status.dart';
import 'package:E_Sale_Tech/views/login/register.dart';
import 'package:E_Sale_Tech/views/login/phone_code.dart';
import 'package:E_Sale_Tech/views/login/binding_phone.dart';
import 'package:E_Sale_Tech/views/share/article_details.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Routers {
  static List filterList = [
    '/realNameAuthen',
    '/openShop',
    '/fillInformation',
    '/me/setting'
  ];

  // 路由声明
  static Map<String, Function> routes = {
    // Shop
    '/shop/shopDesign': (context) => ShopDesign(),
    '/shop/shopDesign/modifyShopName': (context) => ModifyShopName(),
    '/shop/shopDesign/modifyShopSignature': (context) => ModifyShopSignature(),
    '/shop/shopDesign/modifyShopQRcode': (context) => ModifyShopQRcode(),
    '/shop/shopDesign/shopDecoration': (context) => ShopDecoration(),
    '/shop/shopDesign/shopDecoration/shopTemplate': (context) => ShopTemplate(),
    '/shop/shopDesign/shopDecoration/shopTemplateImgAd':
        (context, {arguments}) => ShopTemplateImgAd(arguments: arguments),
    '/shop/shopDesign/shopDecoration/shopTemplateGoodsStyle':
        (context, {arguments}) => ShopTemplateGoodsStyle(arguments: arguments),
    '/shop/shopDesign/shopDrag': (context) => ShopDrag(),
    '/shop/orderManager': (context) => OrderManager(),
    '/shop/orderManager/detail': (context, {arguments}) =>
        OrderManagerDetail(arguments: arguments),
    '/shop/orderManager/logisticsDetail': (context, {arguments}) =>
        OrderManagerLogisticsDetail(arguments: arguments),
    '/shop/collection': (context) => Collection(),
    '/shop/collection/batchPutOnShelf': (context, {arguments}) =>
        BatchPutOnShelf(arguments: arguments),
    '/shop/coupon/couponManager': (context) => CouponManager(),
    '/shop/coupon/setCoupon': (context) => SetCoupon(),
    '/shop/coupon/setCouponRange': (context) => SetCouponRange(),
    '/shop/coupon/setCouponSelectGoods': (context, {arguments}) =>
        SetCouponSelectGoods(arguments: arguments),
    '/shop/coupon/setCouponSelectBrand': (context, {arguments}) =>
        SetCouponSelectBrand(arguments: arguments),
    '/shop/coupon/setCouponSelectCategory': (context, {arguments}) =>
        SetCouponSelectCategory(arguments: arguments),
    '/shop/coupon/previewCoupon': (context, {arguments}) =>
        PreviewCoupon(arguments: arguments),
    '/shop/discountStore': (context) => DiscountStore(),
    '/shop/dataStatistic': (context) => DataStatistic(),
    '/webview': (context, {arguments}) => WebViewPage(arguments: arguments),

    // Me
    '/me/myProperty': (context) => MyProperty(),
    '/me/myProperty/applyWithdraw': (context, {arguments}) =>
        ApplyWithdrawPage(arguments: arguments),
    '/me/myProperty/withdrawRecord': (context, {arguments}) =>
        WithdrawRecordPage(arguments: arguments),
    '/me/myAddress': (context, {arguments}) =>
        AddressListPage(arguments: arguments),
    '/me/myAddress/editAddress': (context, {arguments}) =>
        EditAddressPage(arguments: arguments),
    '/me/myInvoice': (context) => InvoiceListPage(),
    '/me/myCustomerService': (context) => CustomerService(),
    '/me/myMsg': (context) => MyMsg(),
    '/me/myMsg/detail': (context, {arguments}) =>
        MsgDetail(arguments: arguments),
    '/me/myProfile': (context) => ComplateProfile(),
    '/me/setting': (context) => Setting(),
    '/me/setting/changePwd': (context) => ChangePwd(),
    '/me/setting/aboutUs': (context) => AboutUs(),

    '/language': (context) => LanguagePage(),
    '/mobileLogin': (context) => MobileLogin(),
    '/login': (context) => Login(),
    '/phoneCode': (context) => PhoneCode(),
    '/register': (context) => Register(),
    '/resetPassword': (context) => ResetPassword(),
    '/openShop': (context) => OpenShopPage(),
    '/fillInformation': (context) => FillInformationPage(),
    '/naviPage': (context) => NaviPage(),
    '/categorieslistPage': (context, {arguments}) =>
        CategoriesListPage(arguments: arguments),
    '/tpyeListPage': (context, {arguments}) =>
        TpyeListPage(arguments: arguments),
    '/realNameAuthen': (context) => RealNamePage(),
    '/goodsPage': (context) => GoodsPage(),
    '/searchPage': (context, {arguments}) => SearchPage(arguments: arguments),
    '/userStatus': (context, {arguments}) => UserStatus(arguments: arguments),
    '/bindingPhone': (context, {arguments}) =>
        BindingPhone(arguments: arguments),
    '/goodsDetailPage': (context, {arguments}) =>
        GoodsDetailPage(arguments: arguments),
    '/editGoodsPricePage': (context, {arguments}) =>
        EditGoodsPricePage(arguments: arguments),
    '/articleDetails': (context, {arguments}) =>
        ArticleDetails(arguments: arguments),
    '/payMentPage': (context, {arguments}) => PayMentPage(arguments: arguments),
    '/orderSettlement': (context, {arguments}) =>
        OrderSettleMentPage(arguments: arguments),
    '/promote/PromotePage': (context, {arguments}) =>
        PromotePage(arguments: arguments),
    '/screening/ScreeningPage': (context) => ScreeningPage(),
  };

  static String currentRouteName = "";

  // 路由初始化
  static run(RouteSettings settings) {
    final Function pageContentBuilder = Routers.routes[settings.name];

    if (pageContentBuilder != null) {
      currentRouteName = settings.name;
      if (settings.arguments != null) {
        // 传参路由
        return CupertinoPageRoute(
            fullscreenDialog: false,
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
      } else {
        // 无参数路由
        return CupertinoPageRoute(
            builder: (context) => pageContentBuilder(context));
      }
    } else {
      // 404页
      return CupertinoPageRoute(builder: (context) => NotFoundPage());
    }
  }

  // 组件跳转
  static link(Widget child, String routeName, BuildContext context,
      [Map parmas]) {
    return GestureDetector(
      onTap: () {
        if (parmas != null) {
          Navigator.pushNamed(context, routeName, arguments: parmas);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: child,
    );
  }

  // 方法跳转
  static push(String routeName, BuildContext context, [Map parmas]) async {
    if (Provider.of<Model>(context, listen: false).token.isEmpty) {
      Navigator.pushNamed(
        context,
        '/login',
      );
      return;
    }
    // if (!await LocalStorage.getHasShop()) {
    //   if (filterList.contains(routeName)) {
    //     Navigator.pushNamed(context, routeName);
    //     return;
    //   }
    //   Navigator.pushNamed(context, '/openShop');
    //   return;
    // }

    if (parmas != null) {
      return Navigator.pushNamed(context, routeName, arguments: parmas)
          .then((value) {
        EasyLoading.dismiss();
        return value;
      });
    } else {
      return Navigator.pushNamed(
        context,
        routeName,
      ).then((value) {
        EasyLoading.dismiss();
        return value;
      });
    }
  }

  // 方法跳转,无返回
  static redirect(String routeName, BuildContext context, [Map parmas]) {
    if (parmas != null) {
      return Navigator.pushReplacementNamed(context, routeName,
          arguments: parmas);
    } else {
      Navigator.pushReplacementNamed(context, routeName); //pushReplacementNamed
    }
  }

  //modal弹出
  static Future<Map> popup(String routeName, BuildContext context,
      [Map parmas]) {
    return Navigator.push(
        context,
        MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            final Function pageContentBuilder = Routers.routes[routeName];
            return pageContentBuilder(
              context,
              arguments: parmas,
            );
          },
          fullscreenDialog: true,
        ));
  }

  static pop(BuildContext context, [Map params]) {
    return Navigator.pop(context, params);
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}
