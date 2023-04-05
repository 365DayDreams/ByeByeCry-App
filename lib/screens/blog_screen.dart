import 'package:bye_bye_cry_new/compoment/product_webview_screen.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/screens/webview_screen.dart';
import 'package:flutter/material.dart';

import '../compoment/shared/outline_button.dart';
import '../compoment/utils/color_utils.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blog Screen"),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: primaryPinkColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0, bottom: 40,left: 30,right: 30),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Image.asset(
                    "asset/images/sounds_image/blog1.jpg",
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0,right: 18,top: 20,bottom: 20),
                  child: Text("The ByeByeCry Blog is written for you, inspired by our experiences with colic. Consider us to be your late-night buddy who gives you advice, laughs and more.",style: TextStyle(
                    fontSize: 18,color: Colors.black,

                  ),textAlign: TextAlign.center,),
                ),

              ),

              SizedBox(height: 20,),
              OutLineButton(
                height: 50,
                width: 300,
                text: 'GO TO BLOG SCREEN'.toUpperCase(),
                textColor: secondaryBlackColor,
                textFontSize: 16,
                textFontWeight: FontWeight.w600,
                borderRadius: 40,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => WebviewPaymentScreen()));

                },
                // textPaddingVerticalTop: 5,
                // textPaddingHorizontal: 47,
              ),
              SizedBox(height: 30,),

              OutLineButton(
                height: 50,
                width: 300,
                text: 'SHOP NOW'.toUpperCase(),
                textColor: secondaryBlackColor,
                textFontSize: 16,
                textFontWeight: FontWeight.w600,
                borderRadius: 40,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => WebviewPaymentScreen2()));

                },
                // textPaddingVerticalTop: 5,
                // textPaddingHorizontal: 47,
              ),

            ],
          ),
        ));
  }
}
