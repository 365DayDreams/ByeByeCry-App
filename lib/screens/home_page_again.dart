
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../compoment/shared/custom_image.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';

class HomePageAgain extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  const HomePageAgain({Key? key,this.onTap}) : super(key: key);

  @override
  ConsumerState<HomePageAgain> createState() => _HomePageAgainPageState();
}

class _HomePageAgainPageState extends ConsumerState<HomePageAgain> {
  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height;

    return Scaffold(
      drawer: SizedBox(
        width: width * 0.6,
        child: Drawer(
          backgroundColor:lightGreen,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.15,),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        color:Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomSvg(svg: crossButtom),
                        ),
                      )),
                ),
                SizedBox(height: width * 0.15,),
                CustomText(text: "text"),
                CustomText(text: "text"),
                CustomText(text: "text"),
                CustomText(text: "text"),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .04,
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: (){
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20.0,top: 20,right: 20,bottom: 10),
                            child: CustomSvg(svg: profile,height:20,width: 20,),
                          ),
                        ),
                      );
                    },
                  ),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      color: primaryWhiteColor,
                      child: CustomImage(
                        imageUrl: 'asset/images/logo_png.png',
                        height: height * .12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(width: width,color: primaryPinkColor,height: 2,),
                ],
              ),
            ),
            SizedBox(height: width * 0.05),
            Container(
              height: width * 0.25,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(text: "Cue the ",fontSize: 36,fontWeight: FontWeight.w600,color: secondaryBlackColor,),
                  Text("calm",style: GoogleFonts.sacramento(
                      fontWeight: FontWeight.w400,fontSize: 64,color: secondaryBlackColor
                  ))
                ],
              ),
            ),
            Container(
                color: Colors.transparent,
                width: width * 0.85,
                child: const CustomImage(imageUrl: sleep_baby)),
            SizedBox(height: width * 0.05),
            OutLineButton(
              height: height * .09,
              text: 'Start Playing'.toUpperCase(),
              textColor: secondaryBlackColor,
              textFontSize: 24,
              textFontWeight: FontWeight.w600,
              borderRadius: 40,
              onPressed: () {},
              textPaddingVerticalTop: 5,
              textPaddingHorizontal: 57,
            ),
            SizedBox(height: width * 0.05),
            Container(
              color: secondaryGreenColor,
              width: width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 21.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding:  EdgeInsets.only(left: 30.0,right: 30,top: 20),
                        child:  CustomSvg(svg: loveSvg),
                      ),
                       Padding(
                         padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 30),
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const CustomSvg(svg: leftDirection),
                            SizedBox(width: width * 0.03),
                             const Expanded(
                              child: CustomText(
                                text: "Does baby have gas? Try This :\nLay baby on their back and bring their knees to their chest. Move baby’s leg in a bicycle motion and apply each time their knees reach their chest ",
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: secondaryBlackColor,
                                textAlign: TextAlign.center,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            const CustomSvg(svg: rightDirection),
                          ],
                      ),
                       )
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height: width * 0.02),
          ],
        ),
      ),
    );
  }
}
