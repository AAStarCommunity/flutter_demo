import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../theme/resorces_list.dart';
import '../../utils/ui/over_repaint_boundary.dart';

class ShareCoffeeBottomSheet extends StatelessWidget {

  final Coffee coffee;
  final String size;

  ShareCoffeeBottomSheet({super.key, required this.coffee, required this.size});
  GlobalKey<OverRepaintBoundaryState> _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.width / 2;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: SingleChildScrollView(child: Column(children: [
          Stack(children: [
            Align(alignment: Alignment.center, child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 4, width: 40, decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),color: Colors.black.withOpacity(.1)))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(""),
              IconButton(onPressed: () {
                Get.back();
              }, icon: Icon(CupertinoIcons.xmark, color: Colors.black.withOpacity(.6)).paddingOnly(right: 16))
            ])
          ]),
        OverRepaintBoundary(
            key: _repaintKey,
            child: RepaintBoundary(child: Container(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),child: Card(clipBehavior: Clip.hardEdge,
                child: SizedBox(child: Column(children: [
                  Image.asset(coffee.image.assetName, width: maxWidth).marginOnly(top: 8),
                  Text("${coffee.name} ${coffee.mix}" * 3, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w300)).paddingSymmetric(horizontal: 12, vertical: 8),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Size: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100)),
                      TextSpan(text: "${size == "S" ? "Small Roasted" : size == "M" ? "Medium Roasted" : "Large Roasted" }", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Price: ", style: TextStyle(fontWeight: FontWeight.w100)),
                      TextSpan(text: "\$ ", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary)),
                      TextSpan(text: "${size == "S" ? coffee.price : size == "M" ? coffee.mediumPrice : coffee.largePrice}", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary
                      ))
                    ]))
                  ]).marginSymmetric(horizontal: 12),
                  const SizedBox(height: 8),
                  SizedBox(width: maxWidth / 2, child: PrettyQrView.data(
                    data: "${jsonEncode(coffee.toJson(size))}",
                    decoration: PrettyQrDecoration(
                      shape: PrettyQrRoundedSymbol(color: Theme.of(context).colorScheme.primary),
                      image: PrettyQrDecorationImage(
                        image: AssetImage("assets/images/ic_launcher.png"),
                      ),
                    ),
                  )).marginOnly(bottom: 0),
                  Text("Your Zu.Coffee journey starts here - Scan", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 8)).marginSymmetric(vertical: 12)
                ]), width: maxWidth)), color: Colors.white))),

          SafeArea(child: CupertinoButton.filled(child: Text("download".tr), onPressed: (){
            _repaintKey.currentState?.saveImage(context);
          }).paddingOnly(bottom: 40))
        ])));
  }
}
