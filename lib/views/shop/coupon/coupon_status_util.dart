class CouponStatus {
  
  static const ALL = 0;
  static const GOODS = 1;
  static const BRAND = 2;
  static const CATEGORY = 3;

  static String scopeFunc(scope) {
    switch (scope) {
      case GOODS:
        return '部分商品';
      case BRAND:
        return '部分品牌';
      case CATEGORY:
        return '部分分类';
        break;
      case ALL:
        return '全部商品';
        break;
      default:
        return '';
    }
  }
}
