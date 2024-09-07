import 'package:HexagonWarrior/pages/account/account_controller.dart';
import 'package:HexagonWarrior/pages/settings/settings_page.dart';
import 'package:HexagonWarrior/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:HexagonWarrior/extensions/extensions.dart';
import '../../utils/ui/show_toast.dart';
import '../account/login_page.dart';

class MyProfile extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 20),
      controller.obx(
          onError: (err) => Center(child: Text("$err")),
          onLoading: const Center(child: CircularProgressIndicator.adaptive()),
          (state) {
        return Column(children: [
          CircleAvatar(radius: 35, foregroundImage: AssetImage("assets/images/def_avatar.png")),
          const SizedBox(height: 24),
          Text("${state?.email}").marginOnly(left: 12, bottom: 20),
          Stack(children: [
            ClipRRect(child: AspectRatio(aspectRatio: 1.66,
                child: Image.asset("assets/images/wallet_background.png",
                width: context.width,
                fit: BoxFit.cover, opacity: AlwaysStoppedAnimation(.2))),
                borderRadius: BorderRadius.circular(12)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: EdgeInsets.only(left: 12, top: 12), child: Text("Balance", style: TextStyle(fontWeight: FontWeight.w600)),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: Color(0xFFED5151), borderRadius: BorderRadius.circular(4))),
              Row(children: [
                Expanded(child: Text("${state?.aa}", overflow: TextOverflow.ellipsis)),
                IconButton(onPressed: () {}, icon: Icon(Icons.copy, color: AppColors.caramelBrown))
              ]).marginOnly(left: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: "\$  ", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, )),
                  TextSpan(text: "${state?.usdtBalance?.trimTrailingZeros() ?? 0}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 44))
                ]))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: 30, child: CupertinoButton.filled(child: Text("charge".tr, style: TextStyle(fontSize: 14)), onPressed: () {
                    showBiometricDialog(context, (index) {
                      if(index == 1){
                        controller.mintUsdt();
                      }
                    });
                }, padding: EdgeInsets.symmetric(horizontal: 14), minSize: 20)),
              ]).marginOnly(top: 12)
            ]),
          ]).marginSymmetric(horizontal: 24)
        ]).marginOnly(top: 20);
      }),
      const SizedBox(height: 30),
      LayoutBuilder(builder: (_, __) {
        final list = [
          ListTile(
              leading: Icon(Icons.manage_accounts, color: AppColors.caramelBrown),
              title: Text("settings".tr),
              onTap: () {
                Get.toNamed(SettingsPage.routeName);
              }),
          ListTile(
              leading: Icon(Icons.logout, color: AppColors.caramelBrown),
              title: Text("logout".tr),
              onTap: () {
                _logout();
              })
        ];
        return Card(margin: EdgeInsets.symmetric(horizontal: 24), child: ListView.separated(itemCount: list.length, separatorBuilder: (_, __) {
          return Divider(thickness: .1, height: 0)
              .paddingSymmetric(horizontal: 18);
        }, itemBuilder: (_, index) {
          return list[index];
        },physics: NeverScrollableScrollPhysics(), shrinkWrap: true, ), clipBehavior: Clip.hardEdge);
      }),
    ]);
  }

  _logout() async{
    showLoading();
    try {
      final res = await Get.find<AccountController>().logout();
      if(res.success) {
        Get.offAllNamed(LoginPage.routeName);
      } else {
        showSnackMessage(res.msg);
      }
    } catch (e) {
      showSnackMessage(e.toString());
    } finally {
      closeLoading();
    }
  }

}
