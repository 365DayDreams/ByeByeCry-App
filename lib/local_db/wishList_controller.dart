import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:get/get.dart';

import 'cart_repo.dart';

class WishListController extends GetxController {
  List<MusicModel> _cartList = [];
  final CartRepo cartRepo = CartRepo();

  getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    if (_cartList.isNotEmpty) {
      _cartList = [];
      cartRepo.addToCartList(_cartList);
    }
  }

  void addToCart(MusicModel cartModel) {
    final isExist = _cartList.contains(cartModel.musicName);
    if (isExist) {
      _cartList.add(cartModel);
    } else {
      _cartList.remove(cartModel);
    }

    cartRepo.addToCartList(_cartList);

    update();
  }

  bool isExist(String musciName) {
    final isExist = _cartList.contains(musciName);
    return isExist;
  }
}
