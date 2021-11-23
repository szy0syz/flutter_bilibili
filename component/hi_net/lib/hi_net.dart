import 'package:hi_net/core/dio_adapter.dart';
import 'package:hi_net/request/hi_base_request.dart';

import 'core/hi_error.dart';
import 'core/hi_net_adapter.dart';

///1.支持网络库插拔设计，且不干扰业务层
///2.基于配置请求请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理
class HiNet {
  HiNet._();
  static HiNet? _instance;

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(HiBaseRequest request) async {
    HiNetResponse? response;
    // ignore: prefer_typing_uninitialized_variables
    var error;

    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //其它异常
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog(result);

    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    ///使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    // ignore: avoid_print
    print('hi_net:' + log.toString());
  }
}
