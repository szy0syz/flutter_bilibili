import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili/barrage/barrage_input.dart';
import 'package:flutter_bilibili/http/dao/favorite_dao.dart';
import 'package:flutter_bilibili/http/dao/like_dao.dart';
import 'package:flutter_bilibili/http/dao/video_detail_dao.dart';
import 'package:flutter_bilibili/model/video_detail_mo.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/util/hi_constants.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:flutter_bilibili/util/view_util.dart';
import 'package:flutter_bilibili/widget/appbar.dart';
import 'package:flutter_bilibili/widget/barrage_switch.dart';
import 'package:flutter_bilibili/widget/expandable_content.dart';
import 'package:flutter_bilibili/widget/hi_tab.dart';
import 'package:flutter_bilibili/widget/navigation_bar.dart';
import 'package:flutter_bilibili/widget/video_header.dart';
import 'package:flutter_bilibili/widget/video_large_card.dart';
import 'package:flutter_bilibili/widget/video_toolbar.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:hi_barrage/hi_barrage.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:hi_video/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论(288)"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];

  var _barrageKey = GlobalKey<HiBarrageState>();

  bool _inputShowing = false;

  @override
  void initState() {
    super.initState();
    // 修复安卓平台黑色状态栏，不要沉浸式
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);

    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadData();
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
      child: (videoModel != null && videoModel?.url != null)
          ? Column(children: [
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
                ),
              )
            ])
          : Container(),
    ));
  }

  _buildVideoView() {
    var model = videoModel;
    if (model?.url == null) {
      return Container(
        child: Text("视频url无效"),
      );
    }

    return VideoView(
      model!.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(
        headers: HiConstants.headers(),
        vid: model.vid,
        key: _barrageKey,
        autoPlay: true,
      ),
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
            _buildBarrageBtn(),
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
      children: [..._buildContents(), ..._buildVideoList()],
    );
  }

  _buildContents() {
    return [
      VideoHeader(owner: videoModel!.owner),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        detailModel: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _doLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadData() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      print(result);

      setState(() {
        videoDetailMo = result;
        // 二次更新旧的VideoModel
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _doLike() async {
    // 会根据当前isLike自动判断取消还是喜欢
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      print(result);
      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  // void _onUnLike() async {}

  void _onFavorite() async {
    try {
      if (videoDetailMo == null || videoModel == null) return;
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      print(result);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }

      setState(() {
        videoModel = videoModel;
        videoDetailMo = videoDetailMo;
      });

      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        initSwtich: _inputShowing,
        onShowInput: () {
          setState(() {
            _inputShowing = true;
          });
          HiOverlay.show(context, child: BarragetInput(
            onTabColse: () {
              setState(() {
                _inputShowing = false;
              });
            },
          )).then((value) {
            print("----input:$value");
            _barrageKey.currentState?.send(value);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState?.play();
          } else {
            _barrageKey.currentState?.pause();
          }
        });
  }
}
