import 'dart:async';
import 'dart:io';

import 'package:bye_bye_cry_new/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../confiq/store_config.dart';


class PurchaseTester extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'RevenueCat Sample',
      home: InitialScreen(),
    );
  }
}

// ignore: public_member_api_docs
class InitialScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<InitialScreen> {
  CustomerInfo ? _customerInfo;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;

      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);

    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();

    final customerInfo = await Purchases.getCustomerInfo();

    Purchases.addReadyForPromotedProductPurchaseListener(
            (productID, startPurchase) async {
          print('Received readyForPromotedProductPurchase event for '
              'productID: $productID');

          try {
            final purchaseResult = await startPurchase.call();
            print('Promoted purchase for productID '
                '${purchaseResult.productIdentifier} completed, or product was'
                'already purchased. customerInfo returned is:'
                ' ${purchaseResult.customerInfo}');
          } on PlatformException catch (e) {
            print('Error purchasing promoted product: ${e.message}');
          }
        });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _customerInfo = customerInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_customerInfo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('RevenueCat Sample App')),
        body: const Center(
          child: Text('Loading...'),
        ),
      );
    } else {
      final isPro = _customerInfo!.entitlements.active.containsKey('pro_cat');
      if (isPro) {
        return HomePage();
      } else {
        return InitialScreen();
      }
    }
  }
}

// ignore: public_member_api_docs
class UpsellScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
  Offerings ? _offerings;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Offerings ?offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _offerings = offerings!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_offerings != null) {
      final offering = _offerings!.current;
      if (offering != null) {
        final monthly = offering.monthly;
        final lifetime = offering.lifetime;

        if (monthly != null && lifetime != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Upsell Screen')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _PurchaseButton(package: monthly),
                  _PurchaseButton(package: lifetime)
                ],
              ),
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Upsell Screen')),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final Package ? package;

  // ignore: public_member_api_docs
  const _PurchaseButton({ @required this.package}) : super();

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () async {
      try {
        final customerInfo = await Purchases.purchasePackage(package!);
        final isPro = customerInfo.entitlements.all['pro_cat']?.isActive;
        if (isPro!) {

        }
      } on PlatformException catch (e) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          print('User cancelled');
        } else if (errorCode ==
            PurchasesErrorCode.purchaseNotAllowedError) {
          print('User not allowed to purchase');
        } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
          print('Payment is pending');
        }
      }

    },
    child: Text('Buy - (${package!.storeProduct.priceString})'),
  );
}

// ignore: public_member_api_docs
class CatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cats Screen')),
    body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('User is pro'),
            ElevatedButton(
              onPressed: () async {
                try {
                  final customerInfo = await Purchases.getCustomerInfo();
                  final refundStatus = await Purchases
                      .beginRefundRequestForEntitlement(
                      customerInfo.entitlements.active['pro_cat']!
                  );
                  print('Refund request successful with status: $refundStatus');
                } catch (e) {
                  print('Refund request exception: $e');
                }

              },
              child: const Text('Begin refund for pro_cat entitlement'),
            ),
          ],
        )
    ),
  );
}
