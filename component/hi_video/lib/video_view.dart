import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hi_video/hi_video_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

///带缓存的image
Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (
        BuildContext context,
        String url,
      ) =>
          Container(color: Colors.grey[200]),
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) =>
          const Icon(Icons.error),
      imageUrl: url);
}

class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget? overlayUI;
  final Widget? barrageUI;
  final Color? primaryColor;

  const VideoView(this.url,
      {Key? key,
      this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUI,
      this.barrageUI,
      this.primaryColor = const Color.fromRGBO(255, 0, 0, 0.7)})
      : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  // 视频封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover ?? ""),
      );

  //进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: widget.primaryColor!,
      handleColor: widget.primaryColor!,
      backgroundColor: Colors.grey,
      bufferedColor: widget.primaryColor!);

  @override
  void initState() {
    // 务必先初始化父类的
    super.initState();
    // 初始化播放器设置
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        allowMuting: true,
        placeholder: _placeholder,
        allowPlaybackSpeedChanging: true,
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          overlayUI: widget.overlayUI,
          barrageUI: widget.barrageUI,
          bottomGradient: blackLinearGradient(),
        ),
        materialProgressColors: _progressColors);
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  // 特别针对 iOS 修复退出全屏问题
  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
