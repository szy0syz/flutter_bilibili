import 'package:flutter/material.dart';
import 'package:flutter_bilibili/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bilibili/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

/// 顶部Tab切换组件
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 13,
      this.borderWidth = 3,
      this.insets = 15,
      this.unselectedLabelColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLabelColor =
        themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;

    return TabBar(
      tabs: tabs,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: _unselectedLabelColor,
      labelStyle: TextStyle(fontSize: fontSize),
      controller: controller,
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.square,
        borderSide: BorderSide(color: primary, width: borderWidth),
        insets: EdgeInsets.only(left: insets, right: insets),
      ),
    );
  }
}
