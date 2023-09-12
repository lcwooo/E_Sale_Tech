import 'package:E_Sale_Tech/api/shop.dart';
import 'package:E_Sale_Tech/model/shop/statistics_sales_info.dart';
import 'package:E_Sale_Tech/model/shop/statistics_trade_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:E_Sale_Tech/views/shop/data_statistic/data_statistic_provider.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/utils/style.dart';

List<Color> gradientColors = [
  const Color(0xff9C2751),
  const Color(0xffE54B40),
];
TextStyle valueTextStyle =
    TextStyle(color: Color(0xffD94543), fontWeight: FontWeight.bold);

class DataStatistic extends StatefulWidget {
  DataStatistic({this.arguments});
  final Map arguments;
  @override
  _DataStatisticState createState() => new _DataStatisticState();
}

class _DataStatisticState extends State<DataStatistic>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DataStatisticIndexProvider provider = DataStatisticIndexProvider();
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<DataStatisticIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: MyAppBar(
              centerTitle: "数据统计",
            ),
            body: Column(
              key: _bodyKey,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xFFF2F2F7), width: 1))),
                  child: TabBar(
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                    isScrollable: false,
                    controller: _tabController,
                    labelColor: AppColor.themeRed,
                    labelStyle: AppText.textBoldDark14,
                    unselectedLabelColor: AppColor.textNormal,
                    unselectedLabelStyle: AppText.textDark14,
                    indicatorColor: AppColor.themeRed,
                    tabs: <Widget>[
                      const _TabView("交易统计", "", 0),
                      const _TabView("销售额统计", "", 1),
                    ],
                  ),
                ),
                Container(
                  child: Expanded(
                    child: PageView.builder(
                      key: const Key('pageView'),
                      itemCount: 2,
                      onPageChanged: _onPageChange,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return LineChartPage();
                        } else {
                          return LineChartPage2();
                        }
                      },
                    ),
                  ),
                ),
              ],
            )));
  }

  _onPageChange(int index) {
    _tabController.animateTo(index);
    provider.setIndex(index);
  }
}

class _TabView extends StatelessWidget {
  const _TabView(this.tabName, this.tabSub, this.index);

  final String tabName;
  final String tabSub;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStatisticIndexProvider>(
      builder: (_, provider, child) {
        return Tab(
            child: Container(
                child: SizedBox(
          width: 88.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(tabName),
              Offstage(
                  offstage: provider.index != index,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(tabSub,
                        style: TextStyle(fontSize: AppText.smallSize)),
                  )),
            ],
          ),
        )));
      },
    );
  }
}

class LineChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartPageState();
}

class LineChartPageState extends State<LineChartPage> {
  StatisticTradeData tradesData;
  String paramsType = '';
  List<FlSpot> tradesList = [
    FlSpot(0, 0.0),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStatisticsTrades();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getStatisticsTrades() {
    EasyLoading.show(status: '加载中...');
    ApiShop.getStatisticsTrades({'range': paramsType}, (data) {
      List<FlSpot> list = [];
      for (var i = 0; i < data.statisticTradeArr.length; i++) {
        list.add(
            FlSpot(i.toDouble(), data.statisticTradeArr[i].count.toDouble()));
      }
      setState(() {
        tradesData = data;
        tradesList = list;
      });
      EasyLoading.dismiss();
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  right: 28,
                ),
                color: Color(0xff3B0A10),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 47,
                        ),
                        Expanded(
                          child: Container(
                            child: LineChart(
                              sampleData2(),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 250),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.grey
                            .withOpacity(paramsType.isEmpty ? 1.0 : 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          if (paramsType.isEmpty) {
                            paramsType = 'month';
                          } else {
                            paramsType = '';
                          }
                        });
                        getStatisticsTrades();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      '当日交易统计',
                      style: TextStyle(color: Color(0xffD94543)),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text('付款订单数'),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.statisticTradeToday?.count ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text('付款金额'),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.statisticTradeToday?.payment?.toStringAsFixed(2) ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  LineChartData sampleData2() {
    var count = tradesData?.statisticTradeToday?.count ?? 0;
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xffB5334B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 7,
          getTitles: (value) {
            if (paramsType.isEmpty) {
              return '${tradesData?.statisticTradeArr[value.toInt()]?.days ?? ''}';
            } else {
              return '${tradesData?.statisticTradeArr[value.toInt()]?.months ?? ''}';
            }
          },
        ),
        leftTitles: SideTitles(
          interval: count > 7000
              ? count / 100
              : count > 700
                  ? count / 10
                  : count > 70
                      ? count / 7
                      : 1,
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xffB5334B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            return '${value.toInt()}';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: tradesList,
        curveSmoothness: 0,
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ];
  }
}

class LineChartPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartPage2State();
}

class LineChartPage2State extends State<LineChartPage2> {
  StatisticsSalesData tradesData;
  String paramsType = '';
  List<FlSpot> tradesList = [
    FlSpot(0, 0.0),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStatisticsSales();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getStatisticsSales() {
    EasyLoading.show(status: '加载中...');
    ApiShop.getStatisticsSales({'range': paramsType}, (data) {
      setState(() {
        tradesData = data;
        List<FlSpot> list = [];
        for (var i = 0; i < tradesData.statisticsSalesList.length; i++) {
          list.add(FlSpot(i.toDouble(),
              tradesData.statisticsSalesList[i].sales.toDouble()));
        }
        tradesList = list;
      });
      EasyLoading.dismiss();
    }, (message) => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  right: 28,
                ),
                color: Color(0xff3B0A10),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 47,
                        ),
                        Expanded(
                          child: Container(
                            child: LineChart(
                              sampleData2(),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 250),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.grey
                            .withOpacity(paramsType.isEmpty ? 1.0 : 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          if (paramsType.isEmpty) {
                            paramsType = 'month';
                          } else {
                            paramsType = '';
                          }
                        });
                        getStatisticsSales();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      '当日交易统计',
                      style: TextStyle(color: Color(0xffD94543)),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          '销售额',
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.dayCount?.sales?.toStringAsFixed(2) ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          '利润',
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.dayCount?.earnings?.toStringAsFixed(2) ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      '当月交易统计',
                      style: TextStyle(color: Color(0xffD94543)),
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          '销售额',
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.monthCount?.sales?.toStringAsFixed(2) ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          '利润',
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${tradesData?.monthCount?.earnings?.toStringAsFixed(2) ?? 0}',
                                style: valueTextStyle))
                      ],
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  LineChartData sampleData2() {
    var sales = tradesData?.monthCount?.sales ?? 0;
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xffB5334B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 10,
          getTitles: (value) {
            if (paramsType.isEmpty) {
              return '${tradesData?.statisticsSalesList[value.toInt()]?.days ?? ''}';
            } else {
              return '${tradesData?.statisticsSalesList[value.toInt()]?.months ?? ''}';
            }
          },
        ),
        leftTitles: SideTitles(
          interval: sales > 700000
              ? sales / 10000
              : sales > 70000
                  ? sales / 10000
                  : sales > 7000
                      ? sales / 70
                      : 10,
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xffB5334B),
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
          getTitles: (value) {
            return '${value.toInt()}';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      gridData: FlGridData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: tradesList,
        curveSmoothness: 0,
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: gradientColors,
          // colors:
          //     gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ];
  }
}
