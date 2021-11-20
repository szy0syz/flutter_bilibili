import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili/barrage/barrage_item.dart';
import 'package:flutter_bilibili/barrage/hi_socket.dart';
import 'package:flutter_bilibili/barrage/ibarrage.dart';
import 'package:flutter_bilibili/model/barrage_model.dart';

enum BarrageStatus {
  play,
  pause,
}

/// 弹幕组件
class HiBarrage extends StatefulWidget {
  final int lintCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;

  HiBarrage(
      {Key? key,
      this.lintCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false})
      : super(key: key);

  @override
  _HiBarrageState createState() => _HiBarrageState();
}

class _HiBarrageState extends State<HiBarrage> implements IBarrage {
  HiSocket? _hiSocket;
  double? _height;
  double? _width;
  List<BarrageItem> _barrageItemList = []; //弹幕widget集合
  List<BarrageModel> _barrageModelList = []; //弹幕模型集合
  int _barrageIndex = 0;
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket!.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_hiSocket != null) {
      _hiSocket!.close();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width! / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(children: [
        //防止Stack的children为空
        Container(),
      ],),
    );
  }

  ///处理消息，instant=true，就马上发送
  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }
    //收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }

    //收到新的弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print("action:play");
    if (_timer != null && _timer!.isActive) return;

    //每个一段时间发一次弹幕
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        //将发送的弹幕从集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print("start:${temp.content}");
      } else {
        print("all barrage are sent.");
        //弹幕发送完毕后关闭定时器
        _timer!.cancel();
      }
    });
  }

  void addBarrage(BarrageModel temp) {}

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    //清空屏幕上的弹幕
    _barrageItemList.clear();
    setState(() {});
    _timer?.cancel();
    print("action:pause");
  }

  @override
  void send(String? message) {
    if (message == null) return;

    _hiSocket?.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }
}
