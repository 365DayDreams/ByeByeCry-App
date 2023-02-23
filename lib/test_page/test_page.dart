import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../compoment/utils/color_utils.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final  _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '1.99',
      status: PaymentItemStatus.final_price,
    )
  ];

   Pay ? _payClient;

@override
  void initState() {
  if(Platform.isIOS){
    getPayApple();
  }else{
    getPay();
  }

   // getPayApple();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryPinkColor,

      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Image.asset("asset/images/bby_cry2.png",
                fit: BoxFit.cover,height: 200,width: double.infinity,),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Center(
                child: Text("Choose an Option",style: TextStyle(
                  fontSize: 25,color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),

            SizedBox(height: 30,),


            InkWell(
              onTap: (){
                if(Platform.isIOS){
                  onApplePayPressed();

                }else if (Platform.isAndroid){
                  onGooglePayPressed();
                }
                setState(() {

                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey,border: Border.all(
                   // color: Colors.grey,
                    width: 0.1
                  )),

                  width: double.infinity,
                  child: Card(

                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Annual",style: TextStyle(
                            fontSize: 17,color: Colors.grey
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("7 DAYS TRAIL",style: TextStyle(
                              fontSize: 22,color: Colors.black
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0,bottom: 10),
                          child: Text("Then bdt 5000 per month bill annulay ",style: TextStyle(
                              fontSize: 14,color: Colors.grey
                          ),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30,),


            InkWell(
              onTap: (){
                if(Platform.isIOS){
                  onApplePayPressed();

                }else if (Platform.isAndroid){
                  onGooglePayPressed();
                }
                setState(() {

                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey,border: Border.all(
                    // color: Colors.grey,
                      width: 0.1
                  )),

                  width: double.infinity,
                  child: Card(

                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Monthy",style: TextStyle(
                              fontSize: 17,color: Colors.grey
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("START TODAY",style: TextStyle(
                              fontSize: 22,color: Colors.black
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0,bottom: 10),
                          child: Text("Then bdt 5000 per month bill annulay ",style: TextStyle(
                              fontSize: 14,color: Colors.grey
                          ),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
      )
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //
      //       GooglePayButton(
      //         onError: (val){},
      //         onPressed: (){
      //
      //         },
      //
      //         paymentConfigurationAsset: "json/default_payment_profile_google_pay.json",
      //         paymentItems: _paymentItems,
      //         type: GooglePayButtonType.pay,
      //         margin: const EdgeInsets.only(top: 15.0),
      //         onPaymentResult: (val){
      //           print("RES__${val}");
      //         },
      //         loadingIndicator: const Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       ),
      //       ElevatedButton(onPressed: () {
      //
      //         onGooglePayPressed();
      //
      //
      //
      //       }, child: Text("Google Pay"))
      //     ],
      //   ),
      // ),
    );
  }

  void onApplePayPressed() async {
    final result = await _payClient!.showPaymentSelector(
      PayProvider.apple_pay,
      _paymentItems,
    );
    // Send the resulting Google Pay token to your server / PSP
  }
  void onGooglePayPressed() async {
    final result = await _payClient!.showPaymentSelector(
      PayProvider.google_pay,
      _paymentItems,
    );
    // Send the resulting Google Pay token to your server / PSP
  }



// When you are ready to load your configuration
getPay(){
  _payClient = Pay({
    PayProvider.google_pay: PaymentConfiguration.fromJsonString(
        defaultGooglePay
    ),


  });
}
getPayApple(){
  _payClient = Pay({
  PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
  defaultApplePay

    ),


  });
}
  final String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.sams.fish",
    "displayName": "Sam's Fish",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
  }
}''';
  final String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';
// final String defaultGooglePay = '''{
//   "provider": "google_pay",
//   "data": {
//     "environment": "TEST",
//     "apiVersion": 2,
//     "apiVersionMinor": 0,
//     "allowedPaymentMethods": [
//       {
//         "type": "CARD",
//         "tokenizationSpecification": {
//           "type": "PAYMENT_GATEWAY",
//           "parameters": {
//             "gateway": "gateway",
//             "gatewayMerchantId": "gatewayMerchantId"
//           }
//         },
//         "parameters": {
//           "allowedCardNetworks": ["VISA", "MASTERCARD"],
//           "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
//           "billingAddressRequired": true,
//           "billingAddressParameters": {
//             "format": "FULL",
//             "phoneNumberRequired": true
//           }
//         }
//       }
//     ],
//     "merchantInfo": {
//       "merchantId": "",
//       "merchantName": ""
//     },
//     "transactionInfo": {
//       "countryCode": "US",
//       "currencyCode": "USD"
//     }
//   }
// }''';


}
