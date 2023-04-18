import 'package:bye_bye_cry_new/confiq/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:intl/intl.dart';
class PurchasListener{
  static final PurchasListener _singleton = PurchasListener._internal();

  factory PurchasListener() {
    return _singleton;
  }

  PurchasListener._internal();

  static bool isSubscribe=false;

  static init() async {

    Purchases.configure( PurchasesConfiguration(
        StoreConfig.instance.apiKey));

    await Purchases.setLogLevel(LogLevel.debug);

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    print("customerInfo.toJson()");
    print(customerInfo.toJson());

    if (customerInfo.entitlements.all["premium"] != null &&
        customerInfo.entitlements.all["premium"]!.isActive ==
            true && customerInfo.entitlements.all["premium"]!.unsubscribeDetectedAt==null) {
      isSubscribe = true;

      var lastPayDate = customerInfo
          .entitlements.all["premium"]!.latestPurchaseDate;
      var inputFormat = new DateFormat(
          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      DateTime dateTime = inputFormat.parse(lastPayDate);

      //dateTime last payment date.
      //jodi subscribe kora thake tahole eta call hobe

    }


  }
}