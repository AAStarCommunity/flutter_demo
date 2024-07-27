import 'package:get/get.dart';

import '../pages/main_page.dart';
import '../theme/change_language_page.dart';
import '../theme/change_theme_page.dart';

final routes = <GetPage>[
  GetPage(name: MainPage.routeName, page: () => MainPage()),
  GetPage(name: ChangeThemePage.routeName, page: () => ChangeThemePage()),
  GetPage(name: ChangeLanguagePage.routeName, page: () => ChangeLanguagePage())
];