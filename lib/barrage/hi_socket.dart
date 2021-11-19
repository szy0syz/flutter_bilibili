import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/dao/login_dao.dart';
import 'package:flutter_bilibili/model/barrage_model.dart';
import 'package:flutter_bilibili/util/hi_constants.dart';
import 'package:web_socket_channel/io.dart';

/// 负责和后端进行websocket通信
class HiSocket extends ISocket {
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/BV1qt411j7fV';

  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;

  // 心跳间隔秒数，根据服务器实际timeout时间来跳转，这里Nginx服务的timeout为60
  int _intervalSeconds = 50;

  @override
  void close() {
    if (_channel != null) {
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(
      _URL + vid,
      headers: _headers(),
      pingInterval: Duration(seconds: _intervalSeconds),
    );

    _channel?.stream.handleError((error) {
      print('websocket连接发生错误: $error');
    }).listen((message) {
      _handleMessage(message);
    });

    return this;
  }

  _headers() {
    Map<String, dynamic> header = {
      HiConstants.authTokenK: HiConstants.authTokenV,
      HiConstants.courseFlagK: HiConstants.courseFlagV,
    };

    header[LoginDao.BOARDING_PASS] = LoginDao.getBoardingPass();

    return header;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  /// 处理服务端的返回信息
  void _handleMessage(message) {
    print('received: $message');

    var result = BarrageModel.fromJsonString(message);

    if (_callBack != null) {
      _callBack!(result);
    }
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
