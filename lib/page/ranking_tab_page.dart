import 'package:flutter/material.dart';
import 'package:flutter_bilibili/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili/http/dao/ranking_dao.dart';
import 'package:flutter_bilibili/model/ranking_mo.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  RankingTabPage({Key? key, this.sort = "like"}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  get contentChild => Container(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10),
            itemCount: dataList.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              return VideoLargeCard(videoModel: dataList[index]);
            }),
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result = await RankingDao.get(
      widget.sort,
      pageIndex: pageIndex,
      pageSize: 10,
    );
    return result;
  }

  @override
  List<VideoModel> parseList(result) {
    return result.list;
  }
}
