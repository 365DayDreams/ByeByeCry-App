import 'package:bye_bye_cry_new/compoment/utils/color_utils.dart';
import 'package:bye_bye_cry_new/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexcolor/hexcolor.dart';


class WebviewPaymentScreen extends StatefulWidget {
  final int? id;
  final String ? text;
  const WebviewPaymentScreen({Key? key, this.id, this.text}) : super(key: key);

  @override
  State<WebviewPaymentScreen> createState() => _WebviewPaymentScreenState();
}

class _WebviewPaymentScreenState extends State<WebviewPaymentScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        elevation: 3,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [],
        backgroundColor: primaryPinkColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => StartPage()));
          },
        ),
        title: const Text(
          "Blog Screen",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body:
      InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse("https://www.byebyecry.com/blog")
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            // _webViewController = controller;
          },
          androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
          }
      ),
      // WebView(
      //   initialUrl: "https://v2.rebusel.com/api/v1/${widget.text}/${widget.id}",
      //   debuggingEnabled: false,
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
