import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:get/get.dart';

class WishListController extends GetxController {
  List<MusicModel> _cartList = [];
  final CartRepo cartRepo = CartRepo();

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    if (_cartList.isNotEmpty) {
      _cartList = [];
      cartRepo.addToCartList(_cartList);
    }
  }

  void addToCart(MusicModel cartModel, int index) {
    if (index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);
    } else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);

    update();
  }
}
