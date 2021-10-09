# flutter_bili_app

## Notes

```dart
///需要登录的异常
class NeedLogin extends HiNetError {
  NeedLogin({int code: 401, String message: '请先登录'}) : super(code, message);
}

///需要授权的异常
class NeedAuth extends HiNetError {
  NeedAuth(String message, {int code: 403, dynamic data})
      : super(code, message, data: data);
}

///网络异常统一格式类
class HiNetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  HiNetError(this.code, this.message, {this.data});
}
```

关于网络请求的异常封装

- 首先定义异常基类，构造函数 data 可选
- 然后定义来个常见的派生类：需要登录、无权访问，其他异常就 基类 顶上
- 需要登录没 data
- 无权访问 则构造函数都要传三个属性

```dart
/// 网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}
```

- 为啥要创建 `Adapter` 抽象类
- 我们需要所有的 `DioAdapter` `MockAdapter` `GetxAdapter` 都要规矩办事
- 主要是可以放回统一的响应体格式，这样上层操作员，根本不用管底层实现
- 而且这个 `Adapter` 只管发送数据

### JSON

- `flutter packages pub run build_runner build`

## Navigator 2.0

![001](/images/docs/RouterDelegate.png)

> 十分精华，终于找到迁移的感觉了！

```dart
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
```

> 上面这个代码，如果在有业务需求先本地搞点事情读点缓存，再确定怎么渲染时是无法做的到。
>
> 所以我们必须改造：

```dart

```

### HiState

- 为什么要封装 `HiState`
  - 处理页面状态异常
  - `setState()` called after dispose() 问题分析

### 上下拉刷新

- 当我们列表长度不足以撑满一个屏幕时，无法刷新，这样是不对的
  - 这个是 Flutter 的默认行为
  - `physics: const AlwaysScrollableScrollPhysics()`
