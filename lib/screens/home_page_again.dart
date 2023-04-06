import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../compoment/shared/custom_image.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';

class HomePageAgain extends ConsumerStatefulWidget {
  const HomePageAgain({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageAgain> createState() => _HomePageAgainPageState();
}

class _HomePageAgainPageState extends ConsumerState<HomePageAgain> {
  CarouselController buttonCarouselController = CarouselController();


  final List<bool> fav = [false];
  int itemIndex =0;

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height;
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [

            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: primaryWhiteColor,
                      child: CustomImage(
                        boxFit: BoxFit.fill,
                        imageUrl: logo,
                      ),
                    ),
                  ),

                  Container(
                    width: width,
                    color: primaryPinkColor,
                    height: 2,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Cue the ",
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: secondaryBlackColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("calm",
                            style: GoogleFonts.sacramento(
                                fontWeight: FontWeight.w400,
                                fontSize: 64,
                                color: secondaryBlackColor)),
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, right: 28),
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

                        "asset/images/homeslwwp_baby.jpg",
                        fit: BoxFit.cover,

                      ),
                    ),
                  ),

                  SizedBox(height: 15),


                  OutLineButton(
                    height: height * .07,
                    text: 'Start Playing'.toUpperCase(),
                    textColor: secondaryBlackColor,
                    textFontSize: 24,
                    textFontWeight: FontWeight.w600,
                    borderRadius: 40,
                    onPressed: () {
                      ref.read(addProvider).changePage(1);
                    },
                    textPaddingVerticalTop: 5,
                    textPaddingHorizontal: 57,
                  ),
                  SizedBox(height: 10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                       // / height: 120,
                        color: secondaryGreenColor,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11.0),
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            buttonCarouselController.previousPage(
                                                duration:
                                                const Duration(milliseconds: 500),
                                                curve: Curves.easeIn);
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: CustomSvg(svg: leftDirection),
                                              ))),
                                      Expanded(
                                        child: CarouselSlider.builder(
                                          carouselController:
                                          buttonCarouselController,
                                          itemCount: 3,
                                          itemBuilder: (BuildContext context,
                                              int itemIndex, int pageViewIndex) {
                                            fav.add(false);

                                            return Container(
                                              color: Colors.transparent,
                                              child: const CustomText(
                                                text:
                                                "Does baby have gas? Try This :\nLay baby on their back and bring their knees to their chest. Move baby’s leg in a bicycle motion and apply each time their knees reach their chest ",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: secondaryBlackColor,
                                                textAlign: TextAlign.center,
                                                height: 1.3,
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                              aspectRatio: 4.0,
                                              viewportFraction: 1,
                                              autoPlay: true,
                                              enableInfiniteScroll: false,
                                              onPageChanged: (index, reasons) {
                                                setState(() {
                                                  itemIndex = index;
                                                });
                                              }),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            buttonCarouselController.nextPage(
                                                duration:
                                                const Duration(milliseconds: 500),
                                                curve: Curves.easeIn);
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: CustomSvg(svg: rightDirection),
                                              ))),
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                      Positioned(
                          right: 15,
                          bottom: 65,




                          child: IconButton(
                              onPressed: () {
                                fav[itemIndex]= !fav[itemIndex];
                                setState(() {

                                });
                              },
                              icon:
                              !fav[itemIndex] ? Icon(
                                Icons.favorite_border,
                                size: 35,
                                color: primaryPinkColor,
                              ) :
                              Icon(
                                Icons.favorite,
                                size: 35,
                                color: primaryPinkColor,
                              )))

                    ],
                  ),
                ],
              ),
            ),






          ],
        ),
      ),
    );
  }
}
