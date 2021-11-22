import 'package:flutter/material.dart';
import 'package:flutter_bilibili/navigator/bottom_navigator.dart';
import 'package:flutter_bilibili/page/login_page.dart';
import 'package:flutter_bilibili/page/registration_page.dart';
import 'package:flutter_bilibili/page/video_detail_page.dart';

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

/// 自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown }

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 获取 page 对应的 RouterStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } // 现在首页已不再是Home页了
  else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// 监听路由页面跳转
/// 感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _routeJump;

  List<RouteChangeListener> _listeners = [];

  RouteStatusInfo? _current;

  // 首页底部的tab
  RouteStatusInfo? _bottomTab;

  HiNavigator._();

  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }

    return _instance!;
  }

  RouteStatusInfo? getCurrent() {
    return _current;
  }

  // 首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {}

  // 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  ///监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  ///通知路由页面变化
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    //如果打开的是首页，则明确到首页具体的tab
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }
    print('hi_navigator:current:${current.page}');
    
    print('hi_navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current!);
    });

    // 打完收工，当前设置为之前
    _current = current;
  }
}

/// 抽象类提供Navigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
