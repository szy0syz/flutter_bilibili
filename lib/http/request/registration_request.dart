
import 'package:flutter_bilibili/http/request/hi_base_request.dart';

class RegistrationRequest extends HiBaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return '/uapi/user/registration';
  }
}
