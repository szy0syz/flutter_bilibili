import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:hi_base/hi_state.dart';

/// 通用底层带分页和刷新的页面框架
/// M为Dao返回的数据模型，L为列表数据模型，T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  int pageInde = 1;
  List<L> dataList = [];
  bool loading = false;

  ScrollController scrollController = ScrollController();

  get contentChild;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // 最大可滚动距离 - 当前滚动距离
      var distance = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      print('Distance: ${distance.toString()}');
      // 到底边距离小于300 并 没在执行加载异步 并整个容器可滚动距离不能为0
      // fix 当列表高度不满屏幕高度时不执行加载更多
      if (distance < 300 &&
          !loading &&
          scrollController.position.maxScrollExtent != 0) {
        print('----loading----');
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: contentChild,
      ),
      onRefresh: loadData,
      color: primary,
    );
  }

  /// 根据对应页码获取相应数据
  Future<M> getData(int pageIndex);

  ///从M中解析出list数据
  List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print("...上次加载还没完成...");
      return;
    }

    loading = true;

    if (!loadMore) {
      pageInde = 1;
    }

    var currentIndex = pageInde + (loadMore ? 1 : 0);
    print('loading:currentIndex: ${currentIndex.toString()}');

    try {
      var result = await getData(currentIndex);

      setState(() {
        if (loadMore) {
          var newList = parseList(result);
          if (newList.isNotEmpty) {
            dataList = [...dataList, ...newList];

            if (newList.length != 0) {
              pageInde++;
            }
          }
        } else {
          dataList = parseList(result);
        }
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
