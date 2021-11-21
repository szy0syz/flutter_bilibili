import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili/db/hi_cache.dart';
import 'package:flutter_bilibili/util/hi_constants.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>["System", "Light", "Dark"][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ///获取主题
  ThemeMode getThemeMode() {
    String theme = HiCache.getInstance().get(HiConstants.theme);
    // 将字符串主体转换为枚举的主体
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
    }

    return _themeMode!;
  }

  ///设置主体
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  ///自定义主题样式细节
  ThemeData getTheme({bool isDarkMode = false}) {
    
  }
}
