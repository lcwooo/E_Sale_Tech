// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get chinese {
    return Intl.message(
      'Chinese',
      name: 'chinese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get pageHomeConfirm {
    return Intl.message(
      'Confirm',
      name: 'pageHomeConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Welcome {name}`
  String pageHomeWelcome(Object name) {
    return Intl.message(
      'Welcome $name',
      name: 'pageHomeWelcome',
      desc: '',
      args: [name],
    );
  }

  /// `{gender, select, male {Hi man!} female {Hi woman!} other {Hi there!}}`
  String pageHomeWelcomeGender(String gender) {
    return Intl.gender(
      gender,
      male: 'Hi man!',
      female: 'Hi woman!',
      other: 'Hi there!',
      name: 'pageHomeWelcomeGender',
      desc: '',
      args: [gender],
    );
  }

  /// `{role, select, admin {Hi admin!} manager {Hi manager!} other {Hi visitor!}}`
  String pageHomeWelcomeRole(Object role) {
    return Intl.select(
      role,
      {
        'admin': 'Hi admin!',
        'manager': 'Hi manager!',
        'other': 'Hi visitor!',
      },
      name: 'pageHomeWelcomeRole',
      desc: '',
      args: [role],
    );
  }

  /// `{howMany, plural, one{1 message} other{{howMany} messages}}`
  String pageNotificationsCount(num howMany) {
    return Intl.plural(
      howMany,
      one: '1 message',
      other: '$howMany messages',
      name: 'pageNotificationsCount',
      desc: '',
      args: [howMany],
    );
  }

  /// `Mobile quick login`
  String get mobileQuickLogin {
    return Intl.message(
      'Mobile quick login',
      name: 'mobileQuickLogin',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get verificationCode {
    return Intl.message(
      'Please enter the verification code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Click send`
  String get clickSend {
    return Intl.message(
      'Click send',
      name: 'clickSend',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Third party login`
  String get thirdPartyLogin {
    return Intl.message(
      'Third party login',
      name: 'thirdPartyLogin',
      desc: '',
      args: [],
    );
  }

  /// `Share store`
  String get shareStore {
    return Intl.message(
      'Share store',
      name: 'shareStore',
      desc: '',
      args: [],
    );
  }

  /// `Goods`
  String get goods {
    return Intl.message(
      'Goods',
      name: 'goods',
      desc: '',
      args: [],
    );
  }

  /// `Visitor`
  String get visitor {
    return Intl.message(
      'Visitor',
      name: 'visitor',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Shop design`
  String get shopDesign {
    return Intl.message(
      'Shop design',
      name: 'shopDesign',
      desc: '',
      args: [],
    );
  }

  /// `Order management`
  String get orderManagement {
    return Intl.message(
      'Order management',
      name: 'orderManagement',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Discount stores`
  String get discountStores {
    return Intl.message(
      'Discount stores',
      name: 'discountStores',
      desc: '',
      args: [],
    );
  }

  /// `My Goods`
  String get myGoods {
    return Intl.message(
      'My Goods',
      name: 'myGoods',
      desc: '',
      args: [],
    );
  }

  /// `My Property`
  String get myProperty {
    return Intl.message(
      'My Property',
      name: 'myProperty',
      desc: '',
      args: [],
    );
  }

  /// `Data statistics`
  String get dataStatistics {
    return Intl.message(
      'Data statistics',
      name: 'dataStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Account Login`
  String get accountLogin {
    return Intl.message(
      'Account Login',
      name: 'accountLogin',
      desc: '',
      args: [],
    );
  }

  /// `Quick Login`
  String get quickLogin {
    return Intl.message(
      'Quick Login',
      name: 'quickLogin',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get forgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Please input mobile number`
  String get pleaseInputMobileNumber {
    return Intl.message(
      'Please input mobile number',
      name: 'pleaseInputMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please Input Password`
  String get pleaseInputPassword {
    return Intl.message(
      'Please Input Password',
      name: 'pleaseInputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful`
  String get loginSuccessful {
    return Intl.message(
      'Login Successful',
      name: 'loginSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree`
  String get readAgree {
    return Intl.message(
      'I have read and agree',
      name: 'readAgree',
      desc: '',
      args: [],
    );
  }

  /// `Service agreement`
  String get serviceAgreement {
    return Intl.message(
      'Service agreement',
      name: 'serviceAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Address info`
  String get addressInfo {
    return Intl.message(
      'Address info',
      name: 'addressInfo',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `surname`
  String get surname {
    return Intl.message(
      'surname',
      name: 'surname',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password confirmation`
  String get passwordConfirmation {
    return Intl.message(
      'Password confirmation',
      name: 'passwordConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Passwords Are Inconsistent`
  String get passwordsAreInconsistent {
    return Intl.message(
      'Passwords Are Inconsistent',
      name: 'passwordsAreInconsistent',
      desc: '',
      args: [],
    );
  }

  /// `Please Input Name`
  String get pleaseInputName {
    return Intl.message(
      'Please Input Name',
      name: 'pleaseInputName',
      desc: '',
      args: [],
    );
  }

  /// `Please Input Address`
  String get pleaseInputAddress {
    return Intl.message(
      'Please Input Address',
      name: 'pleaseInputAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please Input Email`
  String get pleaseInputEmail {
    return Intl.message(
      'Please Input Email',
      name: 'pleaseInputEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Country`
  String get pleaseSelectCountry {
    return Intl.message(
      'Please Select Country',
      name: 'pleaseSelectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Please check the user agreement`
  String get userAgreement {
    return Intl.message(
      'Please check the user agreement',
      name: 'userAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Back to login`
  String get backLogin {
    return Intl.message(
      'Back to login',
      name: 'backLogin',
      desc: '',
      args: [],
    );
  }

  /// `Search for products or brands`
  String get homeSearchHint {
    return Intl.message(
      'Search for products or brands',
      name: 'homeSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Search brand, category, trade name`
  String get searchPageSearchHint {
    return Intl.message(
      'Search brand, category, trade name',
      name: 'searchPageSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Top Search`
  String get topSearch {
    return Intl.message(
      'Top Search',
      name: 'topSearch',
      desc: '',
      args: [],
    );
  }

  /// `Historical Search`
  String get historySearch {
    return Intl.message(
      'Historical Search',
      name: 'historySearch',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Goods details`
  String get goodDetail {
    return Intl.message(
      'Goods details',
      name: 'goodDetail',
      desc: '',
      args: [],
    );
  }

  /// `Original Price`
  String get originPrice {
    return Intl.message(
      'Original Price',
      name: 'originPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sale Priec`
  String get salePrice {
    return Intl.message(
      'Sale Priec',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Current available inventory:`
  String get availableStock {
    return Intl.message(
      'Current available inventory:',
      name: 'availableStock',
      desc: '',
      args: [],
    );
  }

  /// `Goods origin :`
  String get goodsOrigin {
    return Intl.message(
      'Goods origin :',
      name: 'goodsOrigin',
      desc: '',
      args: [],
    );
  }

  /// `Net content`
  String get netContent {
    return Intl.message(
      'Net content',
      name: 'netContent',
      desc: '',
      args: [],
    );
  }

  /// `Distribution:`
  String get distribution {
    return Intl.message(
      'Distribution:',
      name: 'distribution',
      desc: '',
      args: [],
    );
  }

  /// `Instructions:`
  String get instructions {
    return Intl.message(
      'Instructions:',
      name: 'instructions',
      desc: '',
      args: [],
    );
  }

  /// `Product Specifications`
  String get goodsSpecifications {
    return Intl.message(
      'Product Specifications',
      name: 'goodsSpecifications',
      desc: '',
      args: [],
    );
  }

  /// `Commodity Description`
  String get goodsDescription {
    return Intl.message(
      'Commodity Description',
      name: 'goodsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Edit Price`
  String get editPrice {
    return Intl.message(
      'Edit Price',
      name: 'editPrice',
      desc: '',
      args: [],
    );
  }

  /// `Up Shelves`
  String get upShelves {
    return Intl.message(
      'Up Shelves',
      name: 'upShelves',
      desc: '',
      args: [],
    );
  }

  /// `Off Shelves`
  String get offShelves {
    return Intl.message(
      'Off Shelves',
      name: 'offShelves',
      desc: '',
      args: [],
    );
  }

  /// `Goods Details`
  String get goodsDetails {
    return Intl.message(
      'Goods Details',
      name: 'goodsDetails',
      desc: '',
      args: [],
    );
  }

  /// `Must Know`
  String get mustKnow {
    return Intl.message(
      'Must Know',
      name: 'mustKnow',
      desc: '',
      args: [],
    );
  }

  /// `Place The Order`
  String get placeTheOrder {
    return Intl.message(
      'Place The Order',
      name: 'placeTheOrder',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Lowest Price`
  String get lowestPrice {
    return Intl.message(
      'Lowest Price',
      name: 'lowestPrice',
      desc: '',
      args: [],
    );
  }

  /// `average Selling Price`
  String get averagePrice {
    return Intl.message(
      'average Selling Price',
      name: 'averagePrice',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price ￥`
  String get saleprice1 {
    return Intl.message(
      'Sale Price ￥',
      name: 'saleprice1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter price`
  String get inputPriec {
    return Intl.message(
      'Please enter price',
      name: 'inputPriec',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get enable {
    return Intl.message(
      'Enable',
      name: 'enable',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Inventory`
  String get inventory {
    return Intl.message(
      'Inventory',
      name: 'inventory',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Since The Pays`
  String get owerPays {
    return Intl.message(
      'Since The Pays',
      name: 'owerPays',
      desc: '',
      args: [],
    );
  }

  /// `Orders For Customers`
  String get ordersForCustomers {
    return Intl.message(
      'Orders For Customers',
      name: 'ordersForCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Uniformly Set Profit`
  String get uniformlySetProfit {
    return Intl.message(
      'Uniformly Set Profit',
      name: 'uniformlySetProfit',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get sure {
    return Intl.message(
      'Sure',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `if the selling price exceeds the recommended retail price, the nearest value will be taken`
  String get warmTips {
    return Intl.message(
      'if the selling price exceeds the recommended retail price, the nearest value will be taken',
      name: 'warmTips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter profit`
  String get enterPriFit {
    return Intl.message(
      'Please enter profit',
      name: 'enterPriFit',
      desc: '',
      args: [],
    );
  }

  /// `Proportion Profit`
  String get priFitForpercentage {
    return Intl.message(
      'Proportion Profit',
      name: 'priFitForpercentage',
      desc: '',
      args: [],
    );
  }

  /// `Net Profit`
  String get netProfit {
    return Intl.message(
      'Net Profit',
      name: 'netProfit',
      desc: '',
      args: [],
    );
  }

  /// `Set the commodity profit first`
  String get setTips {
    return Intl.message(
      'Set the commodity profit first',
      name: 'setTips',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get SelectAll {
    return Intl.message(
      'Select All',
      name: 'SelectAll',
      desc: '',
      args: [],
    );
  }

  /// `DEL`
  String get delete {
    return Intl.message(
      'DEL',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get downShelves {
    return Intl.message(
      'Off',
      name: 'downShelves',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}