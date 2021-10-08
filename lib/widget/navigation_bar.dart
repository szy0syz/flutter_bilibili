import 'package:flutter/material.dart';
import 'package:flutter_bilibili/util/view_util.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      required this.child})
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
    // 设置沉浸式状态栏样式
    changeStatusBar();
    // FlutterStatusbarManager.setColor(color, animated: false);
    // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
    //     ? StatusStyle.DARK_CONTENT
    //     : StatusStyle.LIGHT_CONTENT);
  }
}
