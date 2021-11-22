import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HiDefend {
  run(Widget app) {
    //处理框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      // 线上环境，走上报逻辑
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        // 开发期间，走Console抛出
        FlutterError.dumpErrorToConsole(details);
      }
    };

    runZonedGuarded(() {
      runApp(app);
    }, (e, s) => _reportError(e, s));
  }

  _reportError(Object error, StackTrace s) {
    print('catch error: $error');
  }
}
