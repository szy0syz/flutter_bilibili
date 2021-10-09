import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 带 lottie 动画的加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  // 加载动画是否覆盖在原有界面之上
  final bool cover;
  final bool isLoading;

  const LoadingContainer(
      {Key? key,
      required this.child,
      this.cover = true,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : Container()],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
  }

  Widget get _loadingView {
    return Center(child: Lottie.asset('assets/loading.json'));
  }
}
