import 'package:flutter/material.dart';

import '../compoment/shared/custom_image.dart';
import '../compoment/shared/custom_image_text.dart';
import '../compoment/shared/custom_text.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import 'botom_nev_bar/bootom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height;
    List<String> imageUrl = [
      'asset/images/blowdryer.png',
      'asset/images/chainshaw.png',
      'asset/images/jackhammer.png',
      'asset/images/lawnmower.png',
      'asset/images/vaccum.png',
      'asset/images/washer.png'
    ];
    List<String> textUrl = [
      'Jackhammer',
      'Chainshaw',
      'Vaccum',
      'Blowdryer',
      'Lawnmower',
      'Washer',
    ];

    List<String> socialMedia = [
      'asset/images/icon_png/fb.png',
      'asset/images/icon_png/linkedIn.png',
      'asset/images/icon_png/insta.png',
    ];

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CustomImage(
                imageUrl: 'asset/images/logo_png.png',
                height: height * .12,
              ),
            ),
            const Divider(
              color: primaryPinkColor,
              thickness: 2,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: secondaryWhiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CustomText(
                          text: 'Sleep never sounded so ',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        CustomImage(
                          height: 70,
                          width: 70,
                          imageUrl: 'asset/images/good.png',
                        ),
                      ],
                    ),
                    const CustomText(
                      text: 'Re-discover Peace With ByeByeCry',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        'asset/images/baby_cry.png',
                        height: height * .3,
                        width: width * .8,
                        fit: BoxFit.fill,
                      ),
                    ),
                    OutLineButton(
                      height: height * .09,
                      text: 'Mom Made',
                      anotherText: 'Pediatrician Recommended',
                      textColor: secondaryBlackColor2,
                      textFontSize: 22,
                      textFontWeight: FontWeight.w700,
                      borderRadius: 50,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: height * .21,
              padding: const EdgeInsets.all(20),
              color: secondaryGreenColor,
              child: Column(
                children: const [
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      text:
                          '“ByeByeCry completely changed our lives. It turned nap time/feeding time from a dearded activity into one that my sin and I can finally enjoy together. I ams so happy he’s happy!” '),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      text: '-Gabyy,PA'),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      text:
                          '10+ sounds designed specifically to calm Colickly Babies'),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      text:
                          'Our unique sounds can help to soothe your fussy baby and can helpthem eat.Continue using the app even when your little ine grows out onf colic'),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            SizedBox(
              height: height * .35,
              child: GridView.builder(
                  padding: const EdgeInsets.all(2.0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: imageUrl.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //crossAxisCount: 2,
                      mainAxisExtent: 130,
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomImageText(
                      text: textUrl[index],
                      imageUrl: imageUrl[index],
                    );
                  }),
            ),

            OutLineButton(
              height: height * .09,
              text: 'Get Started',
              anotherText: '(For better sleep for them and for you)',
              textColor: secondaryBlackColor2,
              textFontSize: 22,
              textFontWeight: FontWeight.w700,
              borderRadius: 50,
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: height * .19,
              padding: const EdgeInsets.all(20),
              color: secondaryGreenColor,
              child: Column(
                children: const [
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      text:
                          '“The app is a saved us. We would not be surviving without it. We sleep better. Baby sleeps better. Even our dog sleeps better” '),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      text: '-Analisa,NJ'),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const CustomText(
                textAlign: TextAlign.center,
                fontSize: 23,
                fontWeight: FontWeight.w600,
                text: '7 Unique features'),
            const SizedBox(
              height: 10,
            ),

            textCol(
                firstText: 'Never miss a song',
                secondText:
                    'Tired of calls or ads interrupting your baby’s sleep? With the ByeByeCry app, calls will come through, but they will not interrupt the sound playing through app'),

            textCol(
                firstText: 'Multitasking',
                secondText:
                    'Baby finally falls asleep and all you want to do is message a loved one or scroll through Instagram to unwind. Well, we have good news! With this app, you can text, scroll and surf the web without interrupting th e music'),

            textCol(
                firstText: 'Dual Sleep Pragramming',
                secondText:
                    'Don’t want to play chainsaw all day? You can set a timer to let it play for a selected amount of time, then have Ocean sound fade in. That’s right- you can be the DJ to your baby’s own sound machine! Your second sound will fade in at your selected timeline or play continuously. '),
            textCol(
                firstText: 'Single Sleep Programming',
                secondText:
                    'Found your favorite sound? Set a timer or play it continuously.'),
            textCol(
                firstText: 'Sound Mixing',
                secondText:
                    'Mix two Sounds together at the same time to find the perfect sound that soothes baby the best. We love mixing Ocean and Classical'),
            textCol(
                firstText: 'Diamond Screen',
                secondText:
                    'Nervous that the bright light of your phone will wake up baby? Easily dim the light on app screen with the dimmable light feature.'),
            textCol(
                firstText: 'Favorite Tab',
                secondText:
                    'Save your favorite sounds and sleep programs (remember, you are the DJ) for quick, easy access when needed most. Help is only one click way!'),

            const SizedBox(
              height: 20,
            ),
            Container(
              height: height * .25,
              padding: const EdgeInsets.all(20),
              color: secondaryGreenColor,
              child: Column(
                children: const [
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      text:
                          '“This app is my favorite because I don’t miss calls or texts when the sounds are playing and they don’t wake up my daughter! My parents downloaded it on their phones too for when they babysit!” '),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      text: '-Stacy,VA'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: height * .53,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: primaryPinkColor,
                      width: 2.0,
                      style: BorderStyle.solid),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'asset/images/bby_cry2.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CustomText(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            text: 'We’re Here To Help'),
                        SizedBox(
                          height: 20,
                        ),
                        CustomText(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            text:
                                '3 in 10 babies will be diagnosed with colic. You are not alone!'),
                        SizedBox(
                          height: 20,
                        ),
                        CustomText(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            text:
                                'Join our community of moms, parents and caregivers on Instagram!'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            OutLineButton(
              height: height * .1,
              text: 'Tap to join us on IG',
              anotherText: 'We know what you’re going through',
              textColor: secondaryBlackColor2,
              textFontSize: 22,
              textFontWeight: FontWeight.w700,
              borderRadius: 50,
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: height * .22,
              padding: const EdgeInsets.all(20),
              color: secondaryGreenColor,
              child: Column(
                children: const [
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      text:
                          '“We have the app and the sound machine. We keep the sound machine in baby’s room and have the app with us when we leave the house. So convenient.” '),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      text: '-Magge,PA'),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const CustomText(
                textAlign: TextAlign.center,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                text: 'Shop the ByeByeCry\nSound Machine'),
            const SizedBox(
              height: 10,
            ),
            const CustomText(
                textAlign: TextAlign.center,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                text:
                    'All of the sounds you love. in a portable adorable sound machine'),
            const SizedBox(
              height: 30,
            ),
            CustomImage(
              imageUrl: 'asset/images/head_phone.png',
              height: height * .45,
              width: width * .8,
            ),
            const SizedBox(
              height: 30,
            ),

            OutLineButton(
              height: height * .075,
              width: width * .65,
              text: 'Shop On Amazon',
              textColor: secondaryBlackColor2,
              textFontSize: 22,
              textFontWeight: FontWeight.w600,
              borderRadius: 50,
              onPressed: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            OutLineButton(
              height: height * .075,
              width: width * .65,
              text: 'Shop On Website',
              textColor: secondaryBlackColor2,
              textFontSize: 22,
              textFontWeight: FontWeight.w600,
              borderRadius: 50,
              onPressed: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            OutLineButton(
              height: height * .075,
              width: width * .65,
              text: 'Read our Blogs',
              textColor: secondaryBlackColor2,
              textFontSize: 22,
              textFontWeight: FontWeight.w600,
              borderRadius: 50,
              onPressed: () {},
            ),
            const SizedBox(
              height: 30,
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    socialMedia.length,
                    (index) => CustomImage(
                          imageUrl: socialMedia[index],
                      height: height * .075,
                      width: width * .15,
                        ))),

            const SizedBox(
              height: 200,
            ),
            //
          ],
        ),
      ),
    );
  }

  Widget textCol({required String firstText, required String secondText}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: primaryGreyColor,
                      borderRadius: BorderRadius.circular(100)
                      //more than 50% of width makes circle
                      ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                  fontSize: 20, fontWeight: FontWeight.w600, text: firstText),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomText(
              fontSize: 16, fontWeight: FontWeight.w400, text: secondText),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
