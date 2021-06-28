// result.g.dart 将在我们运行生成命令后自动生成
import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  //定义字段
  int code;
  String method;
  String requestPrams;

  Result(this.code, this.method, this.requestPrams);

  //固定格式，不同的类使用不同的mixin即可
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  //固定格式，
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
