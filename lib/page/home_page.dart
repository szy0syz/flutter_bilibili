import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/dao/home_dao.dart';
import 'package:flutter_bilibili/model/home_mo.dart';
import 'package:flutter_bilibili/navigator/hi_navigator.dart';
import 'package:flutter_bilibili/page/home_tab_page.dart';
import 'package:flutter_bilibili/util/color.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;

  // 太牛逼了，原来上下两个 TabBar 是通过这个 controller 联动的
  late TabController _controller;

  List<BannerMo> bannerList = [];
  List<CategoryMo> categoryList = [];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('首页: onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页: onPause');
      }
    });

    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      name: tab.name,
                      bannerList: tab.name == '推荐' ? bannerList : null,
                    );
                  }).toList()))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      isScrollable: true,
      controller: _controller,
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.round,
          borderSide: BorderSide(color: primary, width: 3),
          insets: EdgeInsets.only(left: 15, right: 15)),
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      print('loadData: ${result}');

      if (result.categoryList != null) {
        //tab长度变化后需要重新创建TabController
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }

      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
      });
    } on NeedAuth catch (e) {
      print(2);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(2);
      showWarnToast(e.message);
    }
  }
}
