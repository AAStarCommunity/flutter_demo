import 'package:HexagonWarrior/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/main_page.dart';

class ChangeThemePage extends GetView<ThemeController> {
  static const routeName = '/change_theme';

  ChangeThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: controller.themeModel.backgroundColor,
        appBar: AppBar(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Row(),
          Text("当前主题:${controller.themeModel.name}", style: TextStyle(
            color: controller.themeModel.textColor
          )),
          ...List.generate(ThemeModel.themes.length, (index) {
            var model = ThemeModel.themes[index];
            return ElevatedButton(
                onPressed: () {
                  controller.changeTheme(model);
                  Get.offAllNamed(MainPage.routeName);
                },
                child: Text(model.name, style: TextStyle(
                  color: controller.themeModel.textColor
                )));
          })
        ]));
  }
}
