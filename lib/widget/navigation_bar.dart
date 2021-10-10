import 'package:flutter/material.dart';
import 'package:flutter_bilibili/util/view_util.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

///可自定义样式的沉浸式导航栏
class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    //状态栏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏
    changeStatusBar(color: color, statusStyle: statusStyle);
  }
}