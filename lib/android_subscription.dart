import 'dart:io';
import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/purchase/purchas_listner.dart';
import 'package:bye_bye_cry_new/start_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../compoment/utils/color_utils.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  getOffringIos() {
    Purchases.getOfferings().then((value) {
      offerings = value;
      print("====");
      print(offerings!.all["premium"]!.availablePackages);
      Package product = offerings!.all["premium"]!.availablePackages.firstWhere(
              (element) => element.identifier == "\$rc_annual");

      annul = product.storeProduct.priceString;

      product = offerings!.all["premium"]!.availablePackages.firstWhere(
              (element) => element.identifier == "\$rc_monthly");
      month = product.storeProduct.priceString;

      setState(() {});
    });
  }

  // var annul = "";
  // var month = "";
  @override
  void initState() {
    if(Platform.isIOS){
      getOffringIos();
    }else{
      getOffring();
    }

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
                child: Image.asset("asset/images/homeslwwp_baby.jpg",
                  fit: BoxFit.cover,height: 200,width: double.infinity,),
              ),


              Container(
                decoration: BoxDecoration(
                  color: HexColor("#FFF4F6")
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 38.0,bottom: 38),
                  child: Center(
                    child: Text("Select your subscription",style: TextStyle(
                        fontSize: 25,color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                ),
              ),

              SizedBox(height: 30,),

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Monthy",style: TextStyle(
                        fontSize: 22,color: Colors.black
                    ),),
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: () async {


                      if(Platform.isIOS){
                        print("offerings");
                        print(offerings!.all["premium"]!.availablePackages);
                        Package product = offerings!.all["premium"]!.availablePackages
                            .firstWhere((element) =>
                        element.identifier == "\$rc_monthly");

                        print('product====');
                        print(product);
                        CustomerInfo customerInfo = await Purchases.purchasePackage(
                          product,
                        );
                        try {
                          if (customerInfo.entitlements.all["premium"] != null &&
                              customerInfo.entitlements.all["premium"]!.isActive ==
                                  true) {
                            PurchasListener.isSubscribe = true;
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));
                          //  LocalDB().setAccessToken(PurchasListener.isSubscribe);

                            //success purchas
                          } else {
                            Fluttertoast.showToast(
                                msg: "Subscription failed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));

                            //subscription failed
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Something Went Wrong.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      }else{


                        print("offerings");
                        print(offerings!.all["premium"]!
                            .availablePackages);
                        Package product = offerings!.all["premium"]!
                            .availablePackages
                            .firstWhere(
                                (element) =>
                            element.storeProduct.identifier == "premium");



                        print('product====');
                        print(product);
                        CustomerInfo customerInfo =
                        await Purchases.purchasePackage(
                          product,

                        );
                        try {
                          if (customerInfo.entitlements.all["premium"] != null &&
                              customerInfo.entitlements.all["premium"]!.isActive ==
                                  true) {
                            print("TOken 1---${product.identifier}");
                            PurchasListener.isSubscribe = true;
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));
                           // LocalDB().setAccessToken(PurchasListener.isSubscribe);


                            //success purchas
                          } else {
                            print("TOken 2---${product.identifier}");
                            Fluttertoast.showToast(
                                msg: "Subscription failed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));


                            //subscription failed
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Something Went Wrong.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          //any e
                        }
                      }


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0,right: 28),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)
                        //     border: Border.all(
                        //   // color: Colors.grey,
                        //     width: 0.1
                        // ),
                        ),

                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  [
                            SizedBox(height: 14,),

                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("7 DAYS FREE TRAIL",style: TextStyle(
                                  fontSize: 22,color: Colors.black
                              ),),
                            ),
                            Platform.isIOS ?    Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 10),
                              child: Text("Then  $month bill month ",style: TextStyle(
                                  fontSize: 14,color: Colors.grey
                              ),),
                            ) :  Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 10),
                              child: Text("Then $month bill month ",style: TextStyle(
                                  fontSize: 14,color: Colors.grey
                              ),),
                            ),
                            SizedBox(height: 14,),


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),



SizedBox(height: 20,),
              /// Yearly...
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Annual",style: TextStyle(
                        fontSize: 22,color: Colors.black
                    ),),
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: () async {

                      if(Platform.isIOS){
                        print("offerings");
                        print(offerings!.all["premium"]!.availablePackages);
                        Package product = offerings!.all["premium"]!.availablePackages
                            .firstWhere((element) =>
                        element.identifier == "\$rc_annual");

                        print('product====');
                        print(product);
                        CustomerInfo customerInfo = await Purchases.purchasePackage(
                          product,
                        );

                        try {
                          if (customerInfo.entitlements.all["premium"] != null &&
                              customerInfo.entitlements.all["premium"]!.isActive ==
                                  true) {
                            PurchasListener.isSubscribe = true;
                            //success purchas
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));
                            //LocalDB().setAccessToken(PurchasListener.isSubscribe);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Subscription failed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));

                            //subscription failed
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Something Went Wrong.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          //any e
                        }
                      }else {
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
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));
                            //LocalDB().setAccessToken(PurchasListener.isSubscribe);

                          }else{
                            Fluttertoast.showToast(
                                msg: "Subscription failed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));

                            // Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));

                            //subscription failed
                          }

                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Something Went Wrong.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          //any error
                        }

                   //cbnsnsc




                      }


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0,right: 28),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)
                        ),

                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  [
                            SizedBox(height: 14,),

                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("7 DAYS FREE TRAIL",style: TextStyle(
                                  fontSize: 22,color: Colors.black
                              ),),
                            ),

                        Platform.isIOS ?    Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 10),
                              child: Text("Then $annul bill annulay ",style: TextStyle(
                                  fontSize: 14,color: Colors.grey
                              ),),
                            ) :  Padding(
                          padding: EdgeInsets.only(top: 4.0,bottom: 10),
                          child: Text("Then $annul bill annulay ",style: TextStyle(
                              fontSize: 14,color: Colors.grey
                          ),),
                        ),
                            Text("Save 19% per year!"),
                            SizedBox(height: 14,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30,),



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

              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       TextButton(onPressed: () async {
              //
              //       }, child: Text("Terms & Conditions")),
              //       TextButton(onPressed: () async {
              //         try {
              //           await PurchasListener.init();
              //           //restore success message
              //         }  catch (e) {
              //           //restore any error
              //         }
              //       }, child: Text("Restore Purchases")),
              //       TextButton(onPressed: () async {
              //
              //       }, child: Text("Privecy Policy")),
              //     ],
              //   ),
              // )


            ],
          ),
        )

    );
  }








}

