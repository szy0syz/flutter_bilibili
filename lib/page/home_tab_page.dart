import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/dao/home_dao.dart';
import 'package:flutter_bilibili/model/home_mo.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:flutter_bilibili/widget/hi_banner.dart';
import 'package:flutter_bilibili/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin{
  int pageInde = 1;
  List<VideoModel> videoList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            crossAxisCount: 2,
            itemCount: videoList.length,
            itemBuilder: (BuildContext context, int index) {
              if (widget.bannerList != null && index == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _banner(),
                );
              } else {
                return VideoCard(videoMo: videoList[index]);
              }
            },
            staggeredTileBuilder: (int index) {
              if (widget.bannerList != null && index == 0) {
                return StaggeredTile.fit(2);
              } else {
                return StaggeredTile.fit(1);
              }
            }));
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: HiBanner(widget.bannerList!),
    );
  }

  void _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageInde = 1;
    }

    var currentInde = pageInde + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentInde, pageSize: 50);

      print('home_tab_page: ${result.toJson()}');

      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            videoList = [...videoList, ...result.videoList];
            pageInde++;
          }
        } else {
          videoList = result.videoList;
        }
      });
    } on NeedAuth catch (e) {
      print(2);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(2);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
