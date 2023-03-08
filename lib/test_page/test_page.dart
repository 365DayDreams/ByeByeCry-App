
import 'dart:io';

import 'package:bye_bye_cry_new/initial_home_page.dart';
import 'package:bye_bye_cry_new/purchase/purchas_listner.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../compoment/utils/color_utils.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


@override
  void initState() {
  getOffring();
    super.initState();
  }
Offerings? offerings;
getOffring(){
  Purchases.getOfferings().then((value) {

    offerings = value;
    Package product= offerings!.all["premium"]!
        .availablePackages
        .firstWhere(
            (element) =>
        element.storeProduct.identifier == "annual_sub_1");

    annul=product.storeProduct.priceString;

     product= offerings!.all["premium"]!
        .availablePackages
        .firstWhere(
            (element) =>
        element.storeProduct.identifier == "premium");
    month=product.storeProduct.priceString;

    setState(() {});
  });
}
var annul="";
var month="";

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
              onTap: () async {

                print("offerings");
                print(offerings!.all["premium"]!
                    .availablePackages);
                Package product= offerings!.all["premium"]!
                    .availablePackages
                    .firstWhere(
                        (element) =>
                    element.storeProduct.identifier == "annual_sub_1");

                print('product====');
                print(product);
                CustomerInfo customerInfo=
                    await Purchases.purchasePackage(
                  product,

                );

                try {
                  if (customerInfo.entitlements.all["premium"] != null &&
                      customerInfo.entitlements.all["premium"]!.isActive ==
                          true) {
                    PurchasListener.isSubscribe=true;
                    //success purchas
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> InitialHomePage()));
                  }else{
                    //subscription failed
                  }

                } catch (e) {
                  //any error
                }
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
                      children:  [
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
                          child: Text("Then bdt $annul bill annulay ",style: TextStyle(
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
              onTap: () async {
                 print("offerings");
                 print(offerings!.all["premium"]!
                     .availablePackages);
                Package product= offerings!.all["premium"]!
                   .availablePackages
                    .firstWhere(
                        (element) =>
                    element.storeProduct.identifier == "premium");

                print('product====');
                print(product);
               CustomerInfo customerInfo=
               await Purchases.purchasePackage(
                 product,

               );
               try {
                 if (customerInfo.entitlements.all["premium"] != null &&
                     customerInfo.entitlements.all["premium"]!.isActive ==
                         true) {
                   PurchasListener.isSubscribe=true;
                   //success purchas
                 }else{
                   //subscription failed
                 }

               } catch (e) {
                 //any error
               }

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
                      children:  [
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
                          child: Text("Then bdt $month per month bill annulay ",style: TextStyle(
                              fontSize: 14,color: Colors.grey
                          ),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            if(Platform.isIOS)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "ByeByeCry subscriptions will automatically renew within 24"
                    " hours before the subscription period ends, and you "
                    "will be charged through your iTunes account. You can manage and cancel your subscription"
                    " in your iTunes Account Settings at any time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(onPressed: () async {

                  }, child: Text("Terms & Conditions")),
                  TextButton(onPressed: () async {
                    try {
                     await PurchasListener.init();
                     //restore success message
                    }  catch (e) {
                      //restore any error
                    }
                  }, child: Text("Restore Purchases")),
                  TextButton(onPressed: () async {

                  }, child: Text("Privecy Policy")),
                ],
              ),
            )


          ],
        ),
      )

    );
  }








}
