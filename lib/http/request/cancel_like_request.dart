import 'package:flutter_bilibili/http/request/like_request.dart';
import 'package:hi_net/request/hi_base_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
