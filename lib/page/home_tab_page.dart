import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/dao/home_dao.dart';
import 'package:flutter_bilibili/model/home_mo.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/util/color.dart';
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

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  int pageInde = 1;
  List<VideoModel> videoList = [];
  bool _loading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 最大可滚动距离 - 当前滚动距离
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis: ${dis.toString()}');
      if (dis < 300 && !_loading) {
        print('--------_loading_--------');
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              controller: _scrollController,
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
              })),
      onRefresh: _loadData,
      color: primary,
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: HiBanner(widget.bannerList!),
    );
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;

    if (!loadMore) {
      pageInde = 1;
    }

    var currentIndex = pageInde + (loadMore ? 1 : 0);
    print('loading:currentIndex: ${currentIndex.toString()}');

    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 15);

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

      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
