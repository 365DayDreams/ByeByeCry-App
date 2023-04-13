import 'package:bye_bye_cry_new/screens/models/home_page_fav_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../compoment/utils/color_utils.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourite Screen"),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: primaryPinkColor,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box("homeFav").listenable(),
          builder: (BuildContext context, value, Widget? child) {
            return value.values.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: value.values.length,
                    itemBuilder: (_, index) {
                      List<HomePageFavModel> data = List.from(value.values);
                      return Container(
                          child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          elevation: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Text(
                              " ${index+1}. ${data[index].text}",

                              style:
                                  TextStyle(fontSize: 16, color: Colors.black,height: 1.6),
                            )),
                          ),
                        ),
                      ));
                    },
                  )
                : Center(
                    child: Text(
                      "No Favourite Data",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  );
          },
        ));
  }
}
