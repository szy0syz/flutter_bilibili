import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class BarrageSwitch extends StatefulWidget {
  ///初始是否默认展开
  final bool initSwtich;

  ///是否为输入中
  final bool inoutShowing;

  ///输入框切换回调
  final VoidCallback onShowInput;

  ///展开与伸缩状态切换回调
  final ValueChanged<bool> onBarrageSwitch;

  BarrageSwitch(
      {Key? key,
      this.initSwtich = true,
      this.inoutShowing = false,
      required this.onShowInput,
      required this.onBarrageSwitch})
      : super(key: key);

  @override
  _BarrageSwitchState createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  bool _barrageSwitch = true;

  @override
  void initState() {
    super.initState();
    _barrageSwitch = widget.initSwtich;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.only(left: 10, right: 10),
      margin: const EdgeInsets.only(right: 15),
      alignment: Alignment.center,
      child: Row(
        children: [_buildText(), _buildIcon()],
      ),
    );
  }

  _buildText() {
    var text = widget.inoutShowing ? "弹幕输入中" : "点我发弹幕";

    if (!_barrageSwitch) return Container();

    return InkWell(
      onTap: widget.onShowInput,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  _buildIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _barrageSwitch = !_barrageSwitch;
        });
        widget.onBarrageSwitch(_barrageSwitch);
      },
      child: Icon(
        Icons.live_tv_rounded,
        color: _barrageSwitch ? primary : Colors.grey 
      ),
    );
  }
}
