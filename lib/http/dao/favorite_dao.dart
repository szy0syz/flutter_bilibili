import 'package:flutter_bilibili/http/request/base_request.dart';
import 'package:flutter_bilibili/http/request/cancel_favorite_request.dart';
import 'package:flutter_bilibili/http/request/favorite_request.dart';
import 'package:hi_net/hi_net.dart';

class FavoriteDao {
  // https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}