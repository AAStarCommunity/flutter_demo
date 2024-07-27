import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/translations.dart';

class ChangeLanguagePage extends StatelessWidget {
  static const routeName = '/change_language';

  ChangeLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Row(),
          ...List.generate(AppTranslations.supportLanguages.length, (index) {
            var language = AppTranslations.supportLanguages[index];
            return ElevatedButton(onPressed: (){
              Get.updateLocale(language.item2);
              Get.back();
            }, child: Text(language.item1));
          })
        ]));
  }
}
