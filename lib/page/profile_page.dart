import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/dao/profile_dao.dart';
import 'package:flutter_bilibili/model/profile_mo.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:flutter_bilibili/util/view_util.dart';
import 'package:flutter_bilibili/widget/course_card.dart';
import 'package:flutter_bilibili/widget/hi_banner.dart';
import 'package:flutter_bilibili/widget/hi_blur.dart';
import 'package:flutter_bilibili/widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// AutomaticKeepAliveClientMixin 切换tab时存活
class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  late ProfileMo? _profileMo;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildAppBar(),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
        ),
      ),
    );
  }

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHeader() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name,
        face: _profileMo!.face,
        controller: _controller);
  }

  @override
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      // 设置顶部扩展的可滚动高度
      expandedHeight: 160,
      // 标题栏是否固定
      pinned: true,
      // 定义滚动的空间
      flexibleSpace: FlexibleSpaceBar(
        // 支持连带的视差滚动效果
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(left: 0),
        title: _buildHeader(),
        background: Stack(
          children: [
            Positioned.fill(
              child: cachedImage(
                "https://www.devio.org/img/beauty_camera/beauty_camera4.jpg",
              ),
            ),
            Positioned.fill(child: Hiblur(sigma: 20)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildProfileTab(),
            )
          ],
        ),
      ),
    );
  }

  _buildContentList() {
    if (_profileMo == null) {
      return [];
    }

    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo!.courseList,)
    ];
  }

  _buildBanner() {
    return HiBanner(
      _profileMo!.bannerList,
      bannerHeight: 120,
      padding: const EdgeInsets.only(top: 10, right: 10),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText("收藏", _profileMo!.favorite),
          _buildIconText("点赞", _profileMo!.like),
          _buildIconText("浏览", _profileMo!.browsing),
          _buildIconText("金币", _profileMo!.coin),
          _buildIconText("粉丝", _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
