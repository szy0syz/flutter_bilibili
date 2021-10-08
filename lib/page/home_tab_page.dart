import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/home_mo.dart';
import 'package:flutter_bilibili/widget/hi_banner.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;

  HomeTabPage({Key? key, required this.name, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemBuilder: (BuildContext context, int index) {
              if (widget.bannerList != null && index == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _banner(),
                );
              } else {
                return Text("1");
              }
            },
            staggeredTileBuilder: (int index) {}));
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: HiBanner(widget.bannerList!),
    );
  }
}
