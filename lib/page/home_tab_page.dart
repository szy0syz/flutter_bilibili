import 'package:flutter/material.dart';
import 'package:flutter_bilibili/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili/http/dao/home_dao.dart';
import 'package:flutter_bilibili/model/home_mo.dart';
import 'package:flutter_bilibili/model/video_model.dart';
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

class _HomeTabPageState
    extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  @override
  void initState() {
    /// 为了方便调试重写下
    super.initState();
    print(widget.bannerList);
    print(widget.categoryName);
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: HiBanner(widget.bannerList!),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  get contentChild => StaggeredGridView.countBuilder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        crossAxisCount: 2,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          if (widget.bannerList != null && index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: _banner(),
            );
          } else {
            return VideoCard(videoMo: dataList[index]);
          }
        },
        staggeredTileBuilder: (int index) {
          if (widget.bannerList != null && index == 0) {
            return StaggeredTile.fit(2);
          } else {
            return StaggeredTile.fit(1);
          }
        },
      );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 15);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList;
  }
}
