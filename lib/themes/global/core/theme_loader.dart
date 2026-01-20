import 'package:one_click_builder/themes/Fuzzy/utility/local_storage.dart';

import '../api & model/theme_api.dart';

class ThemeLoader {
  static String currentTheme = "fuzzy";

  static Future<void> loadTheme() async {
    // Load saved theme
    String? savedTheme = await StorageHelper.getSelectedTheme();
    if (savedTheme != null) {
      currentTheme = savedTheme;
      return;
    }

    // Otherwise load from API
    final res = await ThemeService.getThemeData("nexus-preview.1clickbuilder.com");

    if (res != null &&
        res.data != null &&
        res.data!.currentTheme != null) {
      currentTheme = res.data!.currentTheme!;
      StorageHelper.saveSelectedTheme(currentTheme);
    }
  }
}
