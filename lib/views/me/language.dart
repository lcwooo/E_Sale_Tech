// import 'package:E_Sale_Tech/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:E_Sale_Tech/components/common_app_bar.dart';
// import 'package:E_Sale_Tech/app_strings.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/utils/localstorage.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage({this.arguments});
  final Map arguments;
  @override
  _LanguagePageState createState() => new _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String language = '';
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLanguage() async {
    var l = await LocalStorage.getLanguage();
    setState(() {
      language = l;
    });
  }

  void onChangeValue(String value) {
    List valueArr = value.split('_');
    ApplicationEvent.event
        .fire(ChangeLanguage(Locale(valueArr[0], valueArr[1])));
    setState(() {
      this.language = value;
      LocalStorage.saveLanguage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        centerTitle: S.of(context).language,
        isBack: true,
      ),
      body: Column(
        children: <Widget>[
          RadioListTile(
            value: 'zh_CN',
            onChanged: (String value) {
              onChangeValue(value);
            },
            groupValue: this.language,
            title: Text('${S.of(context).chinese}'),
          ),
          RadioListTile(
            value: 'en_''',
            onChanged: (String value) {
              onChangeValue(value);
            },
            groupValue: this.language,
            title: Text('${S.of(context).english}'),
          ),
        ],
      ),
    );
  }
}
