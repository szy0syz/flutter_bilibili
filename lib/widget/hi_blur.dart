import 'dart:ui';

import 'package:flutter/material.dart';

class Hiblur extends StatelessWidget {
  final Widget child;

  final double sigma;

  const Hiblur({Key? key, required this.child, this.sigma = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        child: child,
        color: Colors.white10,
      ),
    );
  }
}
