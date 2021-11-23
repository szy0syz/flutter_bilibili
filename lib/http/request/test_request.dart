
import 'package:flutter_bilibili/http/request/hi_base_request.dart';

class TestRequest extends HiBaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'uapi/test/test';
  }
}
