import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/util/view_util.dart';
import 'package:flutter_bilibili/widget/appbar.dart';
import 'package:flutter_bilibili/widget/hi_tab.dart';
import 'package:flutter_bilibili/widget/navigation_bar.dart';
import 'package:flutter_bilibili/widget/video_header.dart';
import 'package:flutter_bilibili/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videlModel;

  VideoDetailPage(this.videlModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论(288)"];

  @override
  void initState() {
    super.initState();
    // 修复安卓平台黑色状态栏，不要沉浸式
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);

    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: Platform.isIOS,
      context: context,
      child: Column(children: [
        // 修复iOS平台状态栏
        NavigationBar(
          color: Colors.black,
          statusStyle: StatusStyle.LIGHT_CONTENT,
          height: Platform.isAndroid ? 0 : 46,
        ),
        _buildVideoView(),
        _buildTabNavigation(),
        Flexible(
            child: TabBarView(
          controller: _controller,
          children: [
            _buildDetailList(),
            Container(
              child: Text("敬请期待..."),
            )
          ],
        ))
      ]),
    ));
  }

  _buildVideoView() {
    var model = widget.videlModel;
    if (model.url == null) {
      return Container(
        child: Text("视频url无效"),
      );
    }

    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }

  _buildTabNavigation() {
    // 使用 Material 实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.green[100],
      child: Container(
        height: 39,
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [...buildContents()],
    );
  }

  buildContents() {
    var model = widget.videlModel;
    return [
      Container(
        child: VideoHeader(owner: model.owner),
      )
    ];
  }
}
