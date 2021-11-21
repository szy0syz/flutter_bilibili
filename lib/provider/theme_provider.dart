import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili/db/hi_cache.dart';
import 'package:flutter_bilibili/util/color.dart';
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
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        // ignore: deprecated_member_use
        accentColor: isDarkMode ? primary[50] : white,
        //Tab指示器的颜色
        indicatorColor: isDarkMode ? primary[50] : white,
        //页面背景色
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }
}