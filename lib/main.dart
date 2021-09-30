import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/video_model.dart';
import 'package:flutter_bilibili/page/home_page.dart';
import 'package:flutter_bilibili/page/video_detail_page.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    // 定义 route
    var widget = Router(
      routerDelegate: _routeDelegate,
    );

    return MaterialApp(
      home: widget,
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  BiliRoutePath? path;

  // 为 Navigator 设置一个 key，必要的时候可以通过 navigatorKey.currentState
  // 来获取当前 NavigatorState
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // 构建路由栈
    pages = [
      pageWrap(HomePage()),
      if (videoModel != null) pageWrap(VideoDetailPage(videoModel!))
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        // 在这里可以控制是否可以返回
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    this.path = path;
  }
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = '/';

  BiliRoutePath.detail() : location = '/detail';
}

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}
