import 'package:flutter/material.dart';

///可动态改变位置的Header组件
///性能优化：局部刷新的应用@刷新原理
class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;

  HiFlexibleHeader(
      {Key? key,
      required this.name,
      required this.face,
      required this.controller})
      : super(key: key);

  @override
  _HiFlexibleHeaderState createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 30;
  static const double MIN_BOTTOM = 10;

  //滚动范围
  static const MAX_OFFSET = 80;
  double _dyBottom = MAX_BOTTOM;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
        var offset = widget.controller.offset;
        print('offset: $offset'); 
        // 计算出padding变化范围，值域在(0,1)之间
        var dyOffset = (MAX_OFFSET - offset)/MAX_OFFSET;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
