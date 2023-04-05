import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/models/music_models.dart';

class CartRepo {
   static SharedPreferences? sharedPreferences;

   getCartList()async {
    List<String>? carts = [];
    if (sharedPreferences!.containsKey("Fav")) {
      carts = sharedPreferences!.getStringList("Fav");
    }
    List<MusicModel> cartList = [];
    carts!
        .forEach((cart) => cartList.add(MusicModel.fromJson(jsonDecode(cart))));
    return cartList;
  }

   addToCartList(List<MusicModel> cartProductList) async {
    List<String> carts = [];
    cartProductList.forEach((cartModel) => carts.add(jsonEncode(cartModel)));
     await sharedPreferences!.setStringList("Fav", carts);
  }
}