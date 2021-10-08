// 时间转换 将秒转换为 分钟:秒
String durationTransform(int seconds) {
  int m = (seconds / 60).truncate();
  int s = seconds - m * 60;

  if (s < 10) {
    return '$m:$s';
  }

  return '$m:$s';
}

// 数字转万
String countFormat(int count) {
  String views = "";

  if (count > 9999) {
    views = "${(count / 10000).toStringAsFixed(2)}万";
  } else {
    views = count.toString();
  }

  return views;
}
