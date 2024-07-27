import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/change_language_page.dart';
import '../theme/change_theme_page.dart';
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
  @override
  Widget build(BuildContext context) {

    var theme = Get.find<ThemeController>().themeModel;
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          const Row(),
          ElevatedButton(
              onPressed: () {
                Get.toNamed(ChangeThemePage.routeName);
              },
              child: Text("theme".tr, style: TextStyle(color: theme.textColor))),
          ElevatedButton(
              onPressed: () {
                Get.toNamed(ChangeLanguagePage.routeName);
              },
              child: Text("language".tr, style: TextStyle(color: theme.textColor)))
        ]));
  }
}
