import 'package:flutter_bilibili/http/core/hi_net.dart';
import 'package:flutter_bilibili/http/request/cancel_favorite_request.dart';
import 'package:flutter_bilibili/http/request/favorite_request.dart';
import 'package:flutter_bilibili/http/request/hi_base_request.dart';

class FavoriteDao {
  // https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool favorite) async {
    HiBaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}