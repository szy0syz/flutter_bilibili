import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/barrage_model.dart';

/// 负责和后端进行websocket通信
class HiSocket extends ISocket {
  @override
  void close() {
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callback) {
    throw UnimplementedError();
  }

  @override
  ISocket open(String vid) {
    throw UnimplementedError();
  }

  @override
  ISocket send(String message) {
    throw UnimplementedError();
  }
}

abstract class ISocket {
  // 和服务端建立连接
  ISocket open(String vid);

  // 发送弹幕
  ISocket send(String message);

  // 关闭连接
  void close();

  // 监听弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callback);
}
