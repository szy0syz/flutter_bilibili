import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/util/format_util.dart';
import 'package:flutter_bilibili/util/view_util.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoModel;

  const VideoCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 200,
        child: Card(
          // 取消卡片默认边距
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(context),
                _infoText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(videoModel.cover, width: size.width / 2 - 10, height: 120),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
              decoration: BoxDecoration(
                  //渐变
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoModel.view),
                  _iconText(Icons.favorite_border, videoModel.favorite),
                  _iconText(null, videoModel.duration),
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoModel.duration);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(views,
                style: TextStyle(color: Colors.white, fontSize: 10)))
      ],
    );
  }

  _infoText() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 5, top: 5, right: 8, bottom: 5),
        child: Column(
          children: [
            Text(videoModel.title)
          ],
        ),
      ),
    );
  }
}
