import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:flutter/material.dart';

import '../compoment/utils/color_utils.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: primaryPinkColor,

      ),
      body: Center(
        child: CustomText( text: 'BlogScreen',
          fontSize: 60,
        ),
      ),
    );
  }
}
