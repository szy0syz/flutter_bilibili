import 'package:flutter/material.dart';

//弹幕widget
class BarrageItem extends StatelessWidget {
  final String? id;
  final double top;
  final Widget child;
  final ValueChanged? onComplete;
  final Duration duration;

  const BarrageItem(
      {Key? key,
      this.id,
      required this.top,
      required this.child,
      this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Container(child: child),
    );
  }
}
