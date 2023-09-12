// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(name) => "Welcome ${name}";

  static m1(gender) => "${Intl.gender(gender, female: 'Hi woman!', male: 'Hi man!', other: 'Hi there!')}";

  static m2(role) => "${Intl.select(role, {'admin': 'Hi admin!', 'manager': 'Hi manager!', 'other': 'Hi visitor!', })}";

  static m3(howMany) => "${Intl.plural(howMany, one: '1 message', other: '${howMany} messages')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "SelectAll" : MessageLookupByLibrary.simpleMessage("Select All"),
    "accountLogin" : MessageLookupByLibrary.simpleMessage("Account Login"),
    "addressInfo" : MessageLookupByLibrary.simpleMessage("Address info"),
    "availableStock" : MessageLookupByLibrary.simpleMessage("Current available inventory:"),
    "averagePrice" : MessageLookupByLibrary.simpleMessage("average Selling Price"),
    "backLogin" : MessageLookupByLibrary.simpleMessage("Back to login"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "chinese" : MessageLookupByLibrary.simpleMessage("Chinese"),
    "clear" : MessageLookupByLibrary.simpleMessage("Clear"),
    "clickSend" : MessageLookupByLibrary.simpleMessage("Click send"),
    "close" : MessageLookupByLibrary.simpleMessage("Close"),
    "country" : MessageLookupByLibrary.simpleMessage("Country"),
    "dataStatistics" : MessageLookupByLibrary.simpleMessage("Data statistics"),
    "delete" : MessageLookupByLibrary.simpleMessage("DEL"),
    "discount" : MessageLookupByLibrary.simpleMessage("Discount"),
    "discountStores" : MessageLookupByLibrary.simpleMessage("Discount stores"),
    "distribution" : MessageLookupByLibrary.simpleMessage("Distribution:"),
    "downShelves" : MessageLookupByLibrary.simpleMessage("Off"),
    "editPrice" : MessageLookupByLibrary.simpleMessage("Edit Price"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "enable" : MessageLookupByLibrary.simpleMessage("Enable"),
    "english" : MessageLookupByLibrary.simpleMessage("English"),
    "enterPriFit" : MessageLookupByLibrary.simpleMessage("Please enter profit"),
    "favorites" : MessageLookupByLibrary.simpleMessage("Favorites"),
    "forgetPassword" : MessageLookupByLibrary.simpleMessage("Forget Password"),
    "goodDetail" : MessageLookupByLibrary.simpleMessage("Goods details"),
    "goods" : MessageLookupByLibrary.simpleMessage("Goods"),
    "goodsDescription" : MessageLookupByLibrary.simpleMessage("Commodity Description"),
    "goodsDetails" : MessageLookupByLibrary.simpleMessage("Goods Details"),
    "goodsOrigin" : MessageLookupByLibrary.simpleMessage("Goods origin :"),
    "goodsSpecifications" : MessageLookupByLibrary.simpleMessage("Product Specifications"),
    "historySearch" : MessageLookupByLibrary.simpleMessage("Historical Search"),
    "homeSearchHint" : MessageLookupByLibrary.simpleMessage("Search for products or brands"),
    "inputPriec" : MessageLookupByLibrary.simpleMessage("Please enter price"),
    "instructions" : MessageLookupByLibrary.simpleMessage("Instructions:"),
    "inventory" : MessageLookupByLibrary.simpleMessage("Inventory"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "loginSuccessful" : MessageLookupByLibrary.simpleMessage("Login Successful"),
    "lowestPrice" : MessageLookupByLibrary.simpleMessage("Lowest Price"),
    "mobileQuickLogin" : MessageLookupByLibrary.simpleMessage("Mobile quick login"),
    "mustKnow" : MessageLookupByLibrary.simpleMessage("Must Know"),
    "myGoods" : MessageLookupByLibrary.simpleMessage("My Goods"),
    "myProperty" : MessageLookupByLibrary.simpleMessage("My Property"),
    "name" : MessageLookupByLibrary.simpleMessage("name"),
    "netContent" : MessageLookupByLibrary.simpleMessage("Net content"),
    "netProfit" : MessageLookupByLibrary.simpleMessage("Net Profit"),
    "newPassword" : MessageLookupByLibrary.simpleMessage("New Password"),
    "number" : MessageLookupByLibrary.simpleMessage("Number"),
    "offShelves" : MessageLookupByLibrary.simpleMessage("Off Shelves"),
    "orderManagement" : MessageLookupByLibrary.simpleMessage("Order management"),
    "ordersForCustomers" : MessageLookupByLibrary.simpleMessage("Orders For Customers"),
    "originPrice" : MessageLookupByLibrary.simpleMessage("Original Price"),
    "owerPays" : MessageLookupByLibrary.simpleMessage("Since The Pays"),
    "pageHomeConfirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "pageHomeWelcome" : m0,
    "pageHomeWelcomeGender" : m1,
    "pageHomeWelcomeRole" : m2,
    "pageNotificationsCount" : m3,
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "passwordConfirmation" : MessageLookupByLibrary.simpleMessage("Password confirmation"),
    "passwordsAreInconsistent" : MessageLookupByLibrary.simpleMessage("Passwords Are Inconsistent"),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Phone number"),
    "placeTheOrder" : MessageLookupByLibrary.simpleMessage("Place The Order"),
    "pleaseInputAddress" : MessageLookupByLibrary.simpleMessage("Please Input Address"),
    "pleaseInputEmail" : MessageLookupByLibrary.simpleMessage("Please Input Email"),
    "pleaseInputMobileNumber" : MessageLookupByLibrary.simpleMessage("Please input mobile number"),
    "pleaseInputName" : MessageLookupByLibrary.simpleMessage("Please Input Name"),
    "pleaseInputPassword" : MessageLookupByLibrary.simpleMessage("Please Input Password"),
    "pleaseSelectCountry" : MessageLookupByLibrary.simpleMessage("Please Select Country"),
    "priFitForpercentage" : MessageLookupByLibrary.simpleMessage("Proportion Profit"),
    "profit" : MessageLookupByLibrary.simpleMessage("Profit"),
    "quickLogin" : MessageLookupByLibrary.simpleMessage("Quick Login"),
    "readAgree" : MessageLookupByLibrary.simpleMessage("I have read and agree"),
    "register" : MessageLookupByLibrary.simpleMessage("Register"),
    "resend" : MessageLookupByLibrary.simpleMessage("Resend"),
    "resetPassword" : MessageLookupByLibrary.simpleMessage("Reset Password"),
    "salePrice" : MessageLookupByLibrary.simpleMessage("Sale Priec"),
    "saleprice1" : MessageLookupByLibrary.simpleMessage("Sale Price ￥"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "search" : MessageLookupByLibrary.simpleMessage("Search"),
    "searchPageSearchHint" : MessageLookupByLibrary.simpleMessage("Search brand, category, trade name"),
    "serviceAgreement" : MessageLookupByLibrary.simpleMessage("Service agreement"),
    "setTips" : MessageLookupByLibrary.simpleMessage("Set the commodity profit first"),
    "shareStore" : MessageLookupByLibrary.simpleMessage("Share store"),
    "shopDesign" : MessageLookupByLibrary.simpleMessage("Shop design"),
    "submit" : MessageLookupByLibrary.simpleMessage("Submit"),
    "sure" : MessageLookupByLibrary.simpleMessage("Sure"),
    "surname" : MessageLookupByLibrary.simpleMessage("surname"),
    "thirdPartyLogin" : MessageLookupByLibrary.simpleMessage("Third party login"),
    "topSearch" : MessageLookupByLibrary.simpleMessage("Top Search"),
    "uniformlySetProfit" : MessageLookupByLibrary.simpleMessage("Uniformly Set Profit"),
    "upShelves" : MessageLookupByLibrary.simpleMessage("Up Shelves"),
    "userAgreement" : MessageLookupByLibrary.simpleMessage("Please check the user agreement"),
    "verification" : MessageLookupByLibrary.simpleMessage("Verification"),
    "verificationCode" : MessageLookupByLibrary.simpleMessage("Please enter the verification code"),
    "visitor" : MessageLookupByLibrary.simpleMessage("Visitor"),
    "warmTips" : MessageLookupByLibrary.simpleMessage("if the selling price exceeds the recommended retail price, the nearest value will be taken")
  };
}
