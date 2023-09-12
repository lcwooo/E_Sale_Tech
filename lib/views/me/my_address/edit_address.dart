import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/event/application_event.dart';
import 'package:E_Sale_Tech/model/goods/orderPreviewDetail.dart';
import 'package:E_Sale_Tech/utils/util.dart';
import 'package:E_Sale_Tech/views/me/my_address/address_item.dart';
import 'package:E_Sale_Tech/views/me/my_address/province.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:E_Sale_Tech/components/common_app_bar.dart';
import 'package:E_Sale_Tech/components/common_button/raised_button.dart';
import 'package:E_Sale_Tech/generated/l10n.dart';
import 'package:E_Sale_Tech/routers/routers.dart';
import 'package:E_Sale_Tech/utils/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditAddressPage extends StatefulWidget {
  final Map arguments;

  EditAddressPage({this.arguments});

  @override
  _EditAddressPageState createState() {
    return _EditAddressPageState(arguments: arguments);
  }
}

class _EditAddressPageState extends State<EditAddressPage> {
  final Map arguments;
  TextEditingController receiver = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController provinceCityDistrict = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController postCode = TextEditingController();
  TextEditingController setDefault = TextEditingController();
  TextEditingController frontImage = TextEditingController();
  TextEditingController backImage = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController cityStreet = TextEditingController();
  TextEditingController invoiceProvinces = TextEditingController(); // 城市
  TextEditingController invoiceAddress = TextEditingController(); // 街道
  TextEditingController invoicePostcode = TextEditingController(); // 邮编
  TextEditingController invoiceDoorNo = TextEditingController(); // 门牌号
  bool isEdit = false;

  bool _setDefaultAddress = false;

  _EditAddressPageState({this.arguments});

  String version = "";

  final subtitleStyle = TextStyle(color: Color(0xff999999));

  @override
  void initState() {
    super.initState();

    this.frontImage.addListener(() {
      this.setState(() {});
    });
    this.backImage.addListener(() {
      this.setState(() {});
    });

    if (this.arguments['address'] != null) {
      this.isEdit = true;
      var addressInfo = this.arguments['address'] as Address;
      this.receiver.text = addressInfo.name;
      this.idCard.text = addressInfo.idCard;
      this.phone.text = addressInfo.mobile;
      this.provinceCityDistrict.text = addressInfo.provinces;
      this.invoicePostcode.text = addressInfo.postcode;
      this.address.text = addressInfo.address;
      this._setDefaultAddress = addressInfo.isDefault == 1 ? true : false;
      this.frontImage.text = addressInfo.frontImage;
      this.backImage.text = addressInfo.backImage;

      if (this.arguments['type'] != 1) {
        this.country.text = addressInfo.country;
        this.invoiceDoorNo.text = addressInfo.doorNo;
        this.invoiceAddress.text = addressInfo.address;
        this.invoiceProvinces.text = addressInfo.provinces;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF8F8F8),
      appBar: MyAppBar(
        centerTitle: this.isEdit ? '编辑地址' : '新增地址',
      ),
      bottomNavigationBar: Material(
        //底部栏整体的颜色
        color: Color(0xffe4382d),
        child: TextButton(
          child: new Padding(
            padding: new EdgeInsets.all(10),
            child: Text("保存",
                style: TextStyle(
                  fontSize: 18.0, //textsize
                  color: Colors.white, // textcolor
                )),
          ),
          onPressed: () async {
            if (this.invoicePostcode.text.length == 0) {
              Util.showToast('请填写邮编');
              return;
            }
            if (this.phone.text.startsWith('0')) {
              Util.showToast('手机号码格式有误，号码前请不要加0');
              return;
            }
            var params = {
              'provinces': this.provinceCityDistrict.text,
              'address': this.address.text,
              'mobile': this.phone.text,
              'name': this.receiver.text,
              'id_card': this.idCard.text,
              'front_image': this.frontImage.text,
              'back_image': this.backImage.text,
              'is_default': this._setDefaultAddress ? 1 : 0,
              'postcode': this.invoicePostcode.text,
            };
            if (this.arguments['type'] != 1) {
              params['country'] = this.country.text;
              params['provinces'] = this.invoiceProvinces.text;
              params['address'] = this.invoiceAddress.text;
              params['door_no'] = this.invoiceDoorNo.text;
            } else {
              if (this.frontImage.text.length == 0) {
                Util.showToast('上传正面照片');
                return;
              }
              if (this.backImage.text.length == 0) {
                Util.showToast('上传反面照片');
                return;
              }
            }
            print('params $params');
            params['type'] = this.arguments['type'];

            Map result;
            EasyLoading.show(status: '保存地址');
            if (this.isEdit) {
              //编辑地址
              params['id'] = this.arguments['address'].id;
              result = await ApiMe.updateAddresses(params);
            } else {
              //添加地址
              result = await ApiMe.addAddresses(params);
            }
            EasyLoading.dismiss();
            if (result != null && result['ret'] == 1) {
              Util.showToast('${this.isEdit ? '编辑' : '添加'}成功');
              ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
              Routers.pop(context);
            } else {
              Util.showToast(result != null
                  ? result['message']
                  : '${this.isEdit ? '编辑' : '添加'}失败');
            }
            return;
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 120.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ..._buildAddressTypeWidgets(),
              this.arguments['type'] == 1
                  ? Container(
                      height: 74,
                      width: ScreenUtil().screenWidth * 0.9,
                      child: Center(
                        child: Text(
                          '*根据中国海关要求，您购买跨境商品需要提交收货人身份证信息 并实名认证进行清关',
                          style:
                              TextStyle(fontSize: 12, color: AppColor.textRed),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 9.5,
                      width: ScreenUtil().screenWidth,
                    ),
              NormalAddressItem(
                title: '手机号',
                controller: this.phone,
                placeholder: '请输入手机号',
              ),
              ..._buildprovinceCityDistrictWidgets(),
              SizedBox(
                height: 9.5,
                width: ScreenUtil().screenWidth,
              ),
              _buildDefaultAddressItem(),
              SizedBox(
                height: 9.5,
                width: ScreenUtil().screenWidth,
              ),
              this.isEdit
                  ? Container(
                      width: ScreenUtil().screenWidth,
                      height: 44,
                      child: RaisedButtonCustom(
                        textStyle: TextStyle(color: Colors.red),
                        color: Colors.white,
                        txt: this.arguments['type'] == 1 ? '删除收货地址' : '删除发票地址',
                        onPressed: () {
                          showActionSheet(context);
                        },
                      ),
                    )
                  : Text(''),
              this.isEdit
                  ? SizedBox(
                      height: 9.5,
                      width: ScreenUtil().screenWidth,
                    )
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildprovinceCityDistrictWidgets() {
    if (this.arguments['type'] == 1) {
      return [
        NormalAddressItem(
          title: '省市区',
          controller: this.provinceCityDistrict,
          placeholder: '请输入省市区',
          rightWidget: InkWell(
            child: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              Result result = await CityPickers.showCityPicker(
                context: context,
                provincesData: provincesData,
                citiesData: citiesData,
              );
              if (result?.provinceName != null &&
                  result?.cityName != null &&
                  result.areaName != null) {
                this.provinceCityDistrict.text =
                    "${result?.provinceName ?? ''} ${result?.cityName ?? ''} ${result?.areaName ?? ''}";
              }
            },
          ),
        ),
        NormalAddressItem(
          title: '详细地址',
          controller: this.address,
          placeholder: '请勿重复填写省市区',
        ),
        NormalAddressItem(
          title: '邮编',
          controller: this.invoicePostcode,
          placeholder: '请输入邮编',
        ),
      ];
    }
    return [
      NormalAddressItem(
        title: '国家',
        controller: this.country,
        placeholder: '请输入国家',
      ),
      NormalAddressItem(
        title: '城市',
        controller: this.invoiceProvinces,
        placeholder: '请输入城市',
      ),
      NormalAddressItem(
        title: '街道',
        controller: this.invoiceAddress,
        placeholder: '请输入街道',
      ),
      NormalAddressItem(
        title: '邮编',
        controller: this.invoicePostcode,
        placeholder: '请输入邮编',
      ),
      NormalAddressItem(
        title: '门牌号',
        controller: this.invoiceDoorNo,
        placeholder: '请输入门牌号',
      ),
    ];
  }

  void showActionSheet(context) {
    showCupertinoDialog<int>(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text('确认删除地址吗？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () {
                  Navigator.pop(cxt, 1);
                },
              ),
            ],
          );
        }).then((value) async {
      if (value == 1) {
        var result =
            await ApiMe.deleteAddresses({"id": this.arguments['address'].id});
        if (result != null && result['ret'] == 1) {
          Util.showToast('删除成功');
          ApplicationEvent.event.fire(ListRefreshEvent('refresh'));
          Routers.pop(context);
        } else {
          Util.showToast(result != null ? result['message'] : '删除失败');
        }
      }
    });
  }

  List<Widget> _buildAddressTypeWidgets() {
    if (this.arguments['type'] == 1) {
      return [
        UploadIDCardImageItem(
          title: '上传身份证',
          frontController: this.frontImage,
          backController: this.backImage,
          placeholder: '请输入身份证号',
          idCardController: this.idCard,
          nameController: this.receiver,
        ),
        NormalAddressItem(
          title: '收货人',
          controller: this.receiver,
          placeholder: '',
          isFilled: true,
          isEdit: false,
        ),
        NormalAddressItem(
          title: '身份证号',
          controller: this.idCard,
          placeholder: '',
          isFilled: true,
          isEdit: false,
        ),
      ];
    }
    return [
      NormalAddressItem(
        title: '收货人',
        controller: this.receiver,
        placeholder: '请输入收件人',
        isEdit: true,
      ),
    ];
  }

  Widget _buildDefaultAddressItem() {
    return Container(
      height: 60,
      color: AppColor.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 14),
              child: Text('设为默认地址'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: CupertinoSwitch(
                activeColor: AppColor.themeRed,
                value: _setDefaultAddress,
                onChanged: (bool value) {
                  ///点击切换开关的状态
                  setState(() {
                    _setDefaultAddress = value;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
