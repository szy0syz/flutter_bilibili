import 'package:flutter_bilibili/http/core/hi_net.dart';
import 'package:flutter_bilibili/http/request/video_detail_request.dart';
import 'package:flutter_bilibili/model/video_detail_mo.dart';

/// 视频详情页Dao
class VideoDetailDao {
  // https://api.devio.org/uapi/fa/detail/xxxxxxx
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);

    return VideoDetailMo.fromJson(result['data']);

  }
}