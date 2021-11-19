import 'package:flutter_bilibili/http/dao/login_dao.dart';
import 'package:flutter_bilibili/util/hi_constants.dart';

enum HttpMethod { GET, POST, DELETE }

///基础请求
abstract class BaseRequest {
  // curl -X GET "http://api.devio.org/uapi/test/test?requestPrams=11" -H "accept: */*"
  // curl -X GET "https://api.devio.org/uapi/test/test/1
  var pathParams;
  var useHttps = true;

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();
    //拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();

  Map<String, String> params = Map();

  ///添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    HiConstants.authTokenK: HiConstants.authTokenV,
      HiConstants.courseFlagK: HiConstants.courseFlagV,
    // 'course-flag': 'fa',
    // "auth-token": "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa",
  };

  ///添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
