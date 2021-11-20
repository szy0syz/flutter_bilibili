import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili/barrage/barrage_item.dart';
import 'package:flutter_bilibili/barrage/hi_socket.dart';
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

class _HiBarrageState extends State<HiBarrage> {
  HiSocket _hiSocket;
  double _height;
  double _width;
  List<BarrageItem> _barrageItemList = [];  //弹幕widget集合
  List<BarrageModel> _barrageModelList = [];//弹幕模型集合
  int _barrageIndex = 0;
  Random _random = Random();
  BarrageStatus _barrageStatus;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket.open(widget.vid).listen((value) {
        _handleMessage(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // if (_hiSocket != null) {
      _hiSocket.close();
    // }
    // if (_timer !=null) {
      _timer.cancel();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  ///处理消息，instant=true，就马上发送
  void _handleMessage(List<BarrageModel> modelList, { bool instant = false }) {
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

  void play() {
    
  }
}
