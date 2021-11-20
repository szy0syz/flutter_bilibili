import 'package:flutter/material.dart';
import 'package:flutter_bilibili/barrage/barrage_transition.dart';

//弹幕widget
class BarrageItem extends StatefulWidget {
  final String? id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem(
      {Key? key,
      this.id,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  @override
  State<BarrageItem> createState() => _BarrageItemState();
}

class _BarrageItemState extends State<BarrageItem> {
  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BarrageTransition(
        key: _key,
        child: widget.child,
        duration: widget.duration,
        onComplete: (v) {
          widget.onComplete(widget.id);
        },
      ),
    );
  }
}
