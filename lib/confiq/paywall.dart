import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

class PaywallScreen extends StatefulWidget {
  final Offering ? offering;
  const PaywallScreen({Key? key, this.offering}) : super(key: key);

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
