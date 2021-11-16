import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/video_model.dart';

/// 可展开的Widget组件
class ExpandableContent extends StatefulWidget {
  final VideoModel mo;

  ExpandableContent({Key? key, required this.mo}) : super(key: key);

  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  bool _expand = false;

  // 用来管理动画的控制器
  late AnimationController _controller;

  // 生成动画高度的值
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      // 监听动画值的变化
      print("_heightFactor: ${_heightFactor.value}");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          Padding(padding: const EdgeInsets.only(bottom: 8))
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onDoubleTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 通过Expanded让Text获得最大的宽度，以便显示省略号...
          Expanded(
            child: Text(
              widget.mo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 15)),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
          )
        ],
      ),
    );
  }

  void _toggleExpand() {}
}
