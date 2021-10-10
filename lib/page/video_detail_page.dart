import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videlModel;

  VideoDetailPage(this.videlModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          _videoView(),
          Text('视频详情页, vid: ${widget.videlModel.vid}'),
          Text('视频详情页, title: ${widget.videlModel.title}'),
        ]));
  }

  _videoView() {
    var model = widget.videlModel;
    if (model.url == null) {
      return Container(
        child: Text("视频url无效"),
      );
    }

    return VideoView(
      model.url!,
      cover: model.cover,
    );
  }
}
