import 'dart:async';

import 'package:flutter/material.dart';

class HiDefend {
  run(Widget app) {
    runZonedGuarded(() {
      runApp(app);
    }, (e, s) => _reportError(e, s));
  }

  _reportError(Object error, StackTrace s) {
    print('catch error: $error');
  }
}
