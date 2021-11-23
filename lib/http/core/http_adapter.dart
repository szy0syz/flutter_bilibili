import 'package:dio/dio.dart';
import 'package:flutter_bilibili/http/request/hi_base_request.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/core/hi_net_adapter.dart';

///Dio适配器
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    // 搞两个变量，一个没初始化赋值，一个初始化赋值
    var response, options = Options(headers: request.header);
    var error;
    var url = Uri.parse(request.url());

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await http.get(url);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      ///抛出HiNetError
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: await buildRes(response, request));
    }

    return buildRes(response, request);
  }

  ///构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, HiBaseRequest request) {
    return Future.value(HiNetResponse(
        //?.防止response为空
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}
