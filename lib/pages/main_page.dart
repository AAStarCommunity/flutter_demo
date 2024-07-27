import 'package:HexagonWarrior/pages/qrcode/qrcode_page.dart';
import 'package:HexagonWarrior/pages/settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_model.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/';

  MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  int _pageIndex = 0;

  _onDrawerClick(int index){
    switch(index) {
      case 0:
        break;
      case 1:
        Get.toNamed(SettingsPage.routeName);
        break;
      case 2:

        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    var theme = Get.find<ThemeController>().themeModel;
    final drawer = NavigationDrawer(indicatorColor: Colors.transparent, children: [
      NavigationDrawerDestination(icon: CircleAvatar(), label: Text("Nick Name")),
      NavigationDrawerDestination(icon: Icon(Icons.manage_accounts), label: Text("settings".tr)),
      NavigationDrawerDestination(icon: Icon(Icons.logout), label: Text("logout".tr))
    ], onDestinationSelected: _onDrawerClick);
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        drawer: drawer,
        appBar: AppBar(actions: [
          IconButton(onPressed: (){
            Get.toNamed(QRCodePage.routeName);
          }, icon: Icon(CupertinoIcons.camera_viewfinder))
        ]),
        body: Column(children: [

        ]), bottomNavigationBar: BottomNavigationBar(currentIndex: _pageIndex, items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: "账户"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: "账单"
          ),
        ], onTap: (index) {
            if(mounted)setState(() {
              _pageIndex = index;
            });
        }));
  }

  _buildAccount() {

  }

  _buildTransaction() {

  }
}
