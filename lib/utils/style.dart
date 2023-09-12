import 'package:flutter/material.dart';

//颜色配置
class AppColor {
  static const Color primary = Color(0xffB9A15F);
  static const Color themeRed = Color(0xffe4382d);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mainTextColor = Color(0xFF121917);
  static const Color subTextColor = Color(0xff959595);
  static const Color textDark = Color(0xFF333333);
  static const Color textBlack = Color(0xFF1C1717);
  static const Color textNormal = Color(0xFF666666);
  static const Color textGray = Color(0xFF999999);
  static const Color textGrayC = Color(0xFFcccccc);
  static const Color bgGray = Color(0xFFF6F6F6);
  static const Color line = Color(0xffF8F8F8);
  static const Color orderLine = Color(0xFFDDDDDD);
  static const Color textRed = Color(0xFFFF4759);
  static const Color main = Color(0xFF738EDB);
  static const Color warningBg = Color(0xFFFFEED0);
  static const Color warningText = Color(0xFFF3A925);
  static const Color tabbarSelectColor = Color(0xffe4382d);
  static const Color green = Color(0xFF3FBF3F);
}

//文本设置
class AppText {
  static const middleSize = 14.0;
  static const defaultSize = 12.0;
  static const smallSize = 10.0;
  static const extraSmallSize = 8.0;
  static const largeSize = 16.0;
  static const extraLargeSize = 18.0;

  static const middleText = TextStyle(
    color: AppColor.mainTextColor,
    fontSize: middleSize,
  );

  static const middleSubText = TextStyle(
    color: AppColor.subTextColor,
    fontSize: middleSize,
  );

  static const TextStyle textMain12 = const TextStyle(
    fontSize: defaultSize,
    color: AppColor.mainTextColor,
  );
  static const TextStyle textMain14 = const TextStyle(
    fontSize: middleSize,
    color: AppColor.mainTextColor,
  );
  static const TextStyle textNormal12 = const TextStyle(
    fontSize: defaultSize,
    color: AppColor.textNormal,
  );
  static const TextStyle textDark12 = const TextStyle(
    fontSize: defaultSize,
    color: AppColor.textDark,
  );
  static const TextStyle textDark14 = const TextStyle(
    fontSize: middleSize,
    color: AppColor.textDark,
  );
  static const TextStyle textDark16 = const TextStyle(
    fontSize: largeSize,
    color: AppColor.textDark,
  );
  static const TextStyle textBoldDark14 = const TextStyle(
      fontSize: middleSize,
      color: AppColor.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark16 = const TextStyle(
      fontSize: largeSize,
      color: AppColor.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark18 = const TextStyle(
      fontSize: extraLargeSize,
      color: AppColor.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark24 = const TextStyle(
      fontSize: 24.0, color: AppColor.textDark, fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark26 = const TextStyle(
      fontSize: 26.0, color: AppColor.textDark, fontWeight: FontWeight.bold);
  static const TextStyle textGray10 = const TextStyle(
    fontSize: smallSize,
    color: AppColor.textGray,
  );
  static const TextStyle textGray12 = const TextStyle(
    fontSize: defaultSize,
    color: AppColor.textGray,
  );
  static const TextStyle textGray14 = const TextStyle(
    fontSize: middleSize,
    color: AppColor.textGray,
  );
  static const TextStyle textGray16 = const TextStyle(
    fontSize: largeSize,
    color: AppColor.textGray,
  );
  static const TextStyle textGrayC12 = const TextStyle(
    fontSize: defaultSize,
    color: AppColor.textGrayC,
  );
  static const TextStyle textGrayC14 = const TextStyle(
    fontSize: middleSize,
    color: AppColor.textGrayC,
  );
}

class WidgetColor {
  static const int fontColor = 0xFF607173;
  static const int iconColor = 0xFF607173;
  static const int borderColor = 0xFFEFEFEF;
  static const int themeColor = 0xFF512DA8;
}

/// 间隔
class Gaps {
  /// 水平间隔
  static const Widget hGap1 = const SizedBox(width: 1.0);
  static const Widget hGap4 = const SizedBox(width: 4.0);
  static const Widget hGap5 = const SizedBox(width: 5.0);
  static const Widget hGap8 = const SizedBox(width: 8.0);
  static const Widget hGap10 = const SizedBox(width: 10.0);
  static const Widget hGap12 = const SizedBox(width: 12.0);
  static const Widget hGap15 = const SizedBox(width: 15.0);
  static const Widget hGap16 = const SizedBox(width: 16.0);

  /// 垂直间隔
  static const Widget vGap4 = const SizedBox(height: 4.0);
  static const Widget vGap5 = const SizedBox(height: 5.0);
  static const Widget vGap8 = const SizedBox(height: 8.0);
  static const Widget vGap10 = const SizedBox(height: 10.0);
  static const Widget vGap12 = const SizedBox(height: 12.0);
  static const Widget vGap15 = const SizedBox(height: 15.0);
  static const Widget vGap16 = const SizedBox(height: 16.0);
  static const Widget vGap50 = const SizedBox(height: 50);

  static Widget line = const SizedBox(
    height: 0.5,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.line)),
  );

  static Widget verticalBar = const SizedBox(
    height: 44,
    width: 12.5,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.green)),
  );

  static Widget br = const SizedBox(
    height: 20,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.line)),
  );

  static Widget lowBr = const SizedBox(
    height: 10,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.line)),
  );

  static Widget lowBr5 = const SizedBox(
    height: 5,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.line)),
  );

  static Widget columnsLine = const SizedBox(
    height: 5,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: AppColor.line)),
  );

  static const Widget empty = const SizedBox(width: 1.0);
}
