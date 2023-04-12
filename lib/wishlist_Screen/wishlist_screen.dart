// import 'package:bye_bye_cry_new/screens/models/music_models.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// import '../compoment/utils/color_utils.dart';
//
// class WishListScreen extends StatefulWidget {
//   const WishListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WishListScreen> createState() => _WishListScreenState();
// }
//
// class _WishListScreenState extends State<WishListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Favourite Screen"),
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         backgroundColor: primaryPinkColor,
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: Hive.box("fav").listenable(),
//         builder: (BuildContext context, value, Widget? child) {
//           return ListView.builder(
//             shrinkWrap: true,
//             primary: false,
//             itemCount: value.values.length,
//             itemBuilder: (_,index){
//               List<MusicModel> data = List.from(value.values);
//               return Container(
//                 child: Column(
//                   children: [
//                     Text("${data[index].musicName}"),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//
//       )
//     );
//   }
// }
