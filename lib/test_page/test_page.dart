// // import 'dart:io';
// // import 'package:bye_bye_cry_new/purchase/purchas_listner.dart';
// // import 'package:bye_bye_cry_new/start_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:purchases_flutter/purchases_flutter.dart';
// // import '../compoment/utils/color_utils.dart';
// //
// // class TestPage extends StatefulWidget {
// //   const TestPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<TestPage> createState() => _TestPageState();
// // }
// //
// // class _TestPageState extends State<TestPage> {
// //   @override
// //   void initState() {
// //
// //     getOffringIos();
// //
// //     super.initState();
// //   }
// //
// //   Offerings? offerings;
// //   getOffringIos() {
// //     Purchases.getOfferings().then((value) {
// //       offerings = value;
// //       print("====");
// //       print(offerings!.all["premium"]!.availablePackages);
// //       Package product = offerings!.all["premium"]!.availablePackages.firstWhere(
// //           (element) => element.identifier == "\$rc_annual");
// //
// //       annul = product.storeProduct.priceString;
// //
// //       product = offerings!.all["premium"]!.availablePackages.firstWhere(
// //           (element) => element.identifier == "\$rc_monthly");
// //       month = product.storeProduct.priceString;
// //
// //       setState(() {});
// //     });
// //   }
// //
// //   var annul = "";
// //   var month = "";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         backgroundColor: primaryPinkColor,
// //         body: SingleChildScrollView(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 22.0),
// //                 child: Image.asset(
// //                   "asset/images/bby_cry2.png",
// //                   fit: BoxFit.cover,
// //                   height: 200,
// //                   width: double.infinity,
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 38.0),
// //                 child: Center(
// //                   child: Text(
// //                     "Choose an Option",
// //                     style: TextStyle(
// //                         fontSize: 25,
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 30,
// //               ),
// //               InkWell(
// //                 onTap: () async {
// //                   print("offerings");
// //                   print(offerings!.all["premium"]!.availablePackages);
// //                   Package product = offerings!.all["premium"]!.availablePackages
// //                       .firstWhere((element) =>
// //                           element.identifier == "\$rc_annual");
// //
// //                   print('product====');
// //                   print(product);
// //                   CustomerInfo customerInfo = await Purchases.purchasePackage(
// //                     product,
// //                   );
// //
// //                   try {
// //                     if (customerInfo.entitlements.all["premium"] != null &&
// //                         customerInfo.entitlements.all["premium"]!.isActive ==
// //                             true) {
// //                       PurchasListener.isSubscribe = true;
// //                       //success purchas
// //                       Navigator.push(context,
// //                           MaterialPageRoute(builder: (_) => StartPage()));
// //                     } else {
// //                       Navigator.push(context,
// //                           MaterialPageRoute(builder: (_) => StartPage()));
// //
// //                       //subscription failed
// //                     }
// //                   } catch (e) {
// //                     //any error
// //                   }
// //                 },
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                         color: Colors.grey,
// //                         border: Border.all(
// //                             // color: Colors.grey,
// //                             width: 0.1)),
// //                     width: double.infinity,
// //                     child: Card(
// //                       elevation: 3,
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text(
// //                               "Annual",
// //                               style:
// //                                   TextStyle(fontSize: 17, color: Colors.grey),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text(
// //                               "7 DAYS TRAIL",
// //                               style:
// //                                   TextStyle(fontSize: 22, color: Colors.black),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: EdgeInsets.only(top: 4.0, bottom: 10),
// //                             child: Text(
// //                               "Then bdt $annul bill annulay ",
// //                               style:
// //                                   TextStyle(fontSize: 14, color: Colors.grey),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 30,
// //               ),
// //               InkWell(
// //                 onTap: () async {
// //                   print("offerings");
// //                   print(offerings!.all["premium"]!.availablePackages);
// //                   Package product = offerings!.all["premium"]!.availablePackages
// //                       .firstWhere((element) =>
// //                           element.identifier == "\$rc_monthly");
// //
// //                   print('product====');
// //                   print(product);
// //                   CustomerInfo customerInfo = await Purchases.purchasePackage(
// //                     product,
// //                   );
// //                   try {
// //                     if (customerInfo.entitlements.all["premium"] != null &&
// //                         customerInfo.entitlements.all["premium"]!.isActive ==
// //                             true) {
// //                       PurchasListener.isSubscribe = true;
// //                       Navigator.push(context,
// //                           MaterialPageRoute(builder: (_) => StartPage()));
// //
// //                       //success purchas
// //                     } else {
// //                       Navigator.push(context,
// //                           MaterialPageRoute(builder: (_) => StartPage()));
// //
// //                       //subscription failed
// //                     }
// //                   } catch (e) {
// //                     //any error
// //                   }
// //                 },
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                         color: Colors.grey,
// //                         border: Border.all(
// //                             // color: Colors.grey,
// //                             width: 0.1)),
// //                     width: double.infinity,
// //                     child: Card(
// //                       elevation: 3,
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text(
// //                               "Monthy",
// //                               style:
// //                                   TextStyle(fontSize: 17, color: Colors.grey),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text(
// //                               "START TODAY",
// //                               style:
// //                                   TextStyle(fontSize: 22, color: Colors.black),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: EdgeInsets.only(top: 4.0, bottom: 10),
// //                             child: Text(
// //                               "Then bdt $month per month bill annulay ",
// //                               style:
// //                                   TextStyle(fontSize: 14, color: Colors.grey),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               if (Platform.isIOS)
// //                 Container(
// //                   margin: EdgeInsets.symmetric(horizontal: 30),
// //                   child: Text(
// //                     "ByeByeCry subscriptions will automatically renew within 24"
// //                     " hours before the subscription period ends, and you "
// //                     "will be charged through your iTunes account. You can manage and cancel your subscription"
// //                     " in your iTunes Account Settings at any time.",
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       color: Colors.black54,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ),
// //               SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Row(
// //                   children: [
// //                     TextButton(
// //                         onPressed: () async {},
// //                         child: Text("Terms & Conditions")),
// //                     TextButton(
// //                         onPressed: () async {
// //                           try {
// //                             await PurchasListener.init();
// //                             //restore success message
// //                           } catch (e) {
// //                             //restore any error
// //                           }
// //                         },
// //                         child: Text("Restore Purchases")),
// //                     TextButton(
// //                         onPressed: () async {}, child: Text("Privecy Policy")),
// //                   ],
// //                 ),
// //               )
// //             ],
// //           ),
// //         ));
// //   }
// // }
// GestureDetector(
// onTap: () {
// CustomBottomSheet.bottomSheet(context, isDismiss: true,
// child: StatefulBuilder(
// builder: (BuildContext context,
// void Function(void Function()) updateState) {
// return bottomSheet(context: context);
// },
// ));
// },
// child: Container(
// color: Colors.transparent,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Expanded(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CustomText(
// text:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].first?.musicName}+${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].second?.musicName}",
// fontSize: 20,
// fontWeight: FontWeight.w400,
// color: secondaryBlackColor,
// ),
// const SizedBox(
// height: 8,
// child: CustomSvg(
// svg: down_arrow,
// color: blackColorA0,
// )),
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// ),
//
//
// Widget bottomSheet({required BuildContext context}) {
// final width = ScreenSize(context).width;
// return GestureDetector(
// behavior: HitTestBehavior.opaque,
// child: StatefulBuilder(
// builder:
// (BuildContext context, void Function(void Function()) updateState) {
// return Wrap(
// children: [
// Container(
// color: Colors.transparent,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.all(20.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// Container(
// decoration: const BoxDecoration(
// shape: BoxShape.circle,
// color: primaryPinkColor),
// child: const Padding(
// padding: EdgeInsets.all(1.0),
// child: CustomImage(
// imageUrl: playButton,
// height: 30,
// width: 30,
// color: Colors.white,
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 15.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisSize: MainAxisSize.min,
// children: [
// CustomText(
// text:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].title}",
// fontWeight: FontWeight.w600,
// fontSize: 20,
// color: blackColor50),
// const SizedBox(height: 5),
// Flexible(
// fit: FlexFit.loose,
// child: Container(
// color: Colors.transparent,
// width: width * 0.67,
// child: CustomText(
// text:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].first?.musicName} + ${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].second?.musicName} is playing",
// fontWeight: FontWeight.w400,
// fontSize: 14,
// color: blackColor50)))
// ],
// ),
// )
// ],
// ),
// const CustomSvg(svg: arrow_foreword),
// ],
// ),
// ),
// Container(height: 2, color: blackColorD9),
// SingleChildScrollView(
// child: Padding(
// padding: const EdgeInsets.all(20.0),
// child: ListView.builder(
// shrinkWrap: true,
// primary: false,
// itemCount: ref
//     .watch(playlistProvider)
//     .mixMixPlaylist[mixPlaylistIndex]
//     .playListList!
//     .length,
// itemBuilder: (context, index) {
// return Container(
// color: Colors.white,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// CustomText(
// text: "Sound Set ${index + 1}",
// fontSize: 16,
// fontWeight: FontWeight.w600,
// color: blackColor50),
// SizedBox(height: width * 0.05),
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Container(
// color: Colors.transparent,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment.start,
// children: [
// SizedBox(
// width: width * 0.44,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// children: [
// SizedBox(
// height:
// width * 0.1,
// width:
// width * 0.1,
// child:
// CustomImage(
// imageUrl:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].first?.image}",
// boxFit:
// BoxFit.fill,
// )),
// Expanded(
// child: Padding(
// padding:
// const EdgeInsets
//     .all(
// 10.0),
// child: CustomText(
// text:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].first?.musicName}",
// fontSize: 16,
// fontWeight:
// FontWeight
//     .w600,
// color:
// blackColor50),
// ),
// ),
// ],
// ),
// ),
// Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// children: [
// const CustomSvg(
// svg: volume),
// Padding(
// padding:
// const EdgeInsets
//     .symmetric(
// horizontal:
// 5.0),
// child: CustomText(
// text:
// "${(currentVolume * 100).toInt().toString().padLeft(2, "0")}%",
// fontSize: 12,
// fontWeight:
// FontWeight
//     .w600,
// color:
// blackColor50),
// ),
// ],
// ),
// ],
// ),
// ),
// SizedBox(height: width * 0.03),
// Container(
// color: Colors.transparent,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment.start,
// children: [
// SizedBox(
// width: width * 0.44,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// children: [
// SizedBox(
// height:
// width * 0.1,
// width:
// width * 0.1,
// child: CustomImage(
// imageUrl:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].second?.image}",
// boxFit: BoxFit
//     .fill)),
// Padding(
// padding:
// const EdgeInsets
//     .all(10.0),
// child: CustomText(
// text:
// "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].second?.musicName}",
// fontSize: 16,
// fontWeight:
// FontWeight
//     .w600,
// color:
// blackColor50),
// ),
// ],
// ),
// ),
// Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// children: [
// const CustomSvg(
// svg: volume),
// Padding(
// padding:
// const EdgeInsets
//     .symmetric(
// horizontal:
// 5.0),
// child: CustomText(
// text:
// "${(currentVolume * 100).toInt().toString().padLeft(2, "0")}%",
// fontSize: 12,
// fontWeight:
// FontWeight
//     .w600,
// color:
// blackColor50),
// ),
// ],
// ),
// ],
// ),
// ),
// ],
// ),
// Row(
// children: const [
// CustomSvg(svg: timer),
// Padding(
// padding: EdgeInsets.symmetric(
// horizontal: 8.0),
// child: CustomText(
// text: "4 min",
// fontWeight: FontWeight.w600,
// fontSize: 12,
// color: primaryGreyColor,
// ),
// )
// ],
// ),
// GestureDetector(
// onTap: () async {
// playMusicForBottomSheet(
// id: ref
//     .watch(playlistProvider)
//     .mixMixPlaylist[
// mixPlaylistIndex]
//     .playListList![index]
//     .id,
// updateState: updateState,
// );
// if (mounted) {
// updateState(() {});
// }
// },
// child: Container(
// clipBehavior: Clip.hardEdge,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.black
//     .withOpacity(0.1)),
// child: Padding(
// padding:
// const EdgeInsets.all(1.0),
// child: ref
//     .watch(
// playlistProvider)
//     .mixMixPlaylist[
// mixPlaylistIndex]
//     .playListList![
// index]
//     .id !=
// ref
//     .watch(
// playlistProvider)
//     .mixMixPlaylist[
// mixPlaylistIndex]
//     .playListList![
// musicIndex]
//     .id
// ? const CustomImage(
// imageUrl: playButton,
// height: 30,
// width: 30,
// color: blackColor97,
// )
//     : issongplaying1 ||
// issongplaying2
// ? const Padding(
// padding:
// EdgeInsets
//     .all(
// 10.0),
// child: CustomSvg(
// svg:
// pouseButton,
// height: 15,
// width: 15,
// color:
// blackColor97),
// )
//     : const CustomImage(
// imageUrl:
// playButton,
// height: 30,
// width: 30,
// color:
// blackColor97,
// ),
// )),
// )
// ],
// ),
// ],
// ),
// index <
// ref
//     .watch(playlistProvider)
//     .mixMixPlaylist[
// mixPlaylistIndex]
//     .playListList!
//     .length -
// 1
// ? const SizedBox(height: 10)
//     : const SizedBox(),
// index <
// ref
//     .watch(playlistProvider)
//     .mixMixPlaylist[
// mixPlaylistIndex]
//     .playListList!
//     .length -
// 1
// ? Container(
// width: width,
// height: 1.5,
// color: blackColorD9,
// )
//     : const SizedBox(),
// const SizedBox(height: 20)
// ],
// ),
// );
// },
// ),
// ),
// )
// ],
// ),
// ),
// ],
// );
// },
// ),
// );
// }
