import 'package:flutter/material.dart';
import 'package:flutter_bilibili/model/barrage_model.dart';

class BarrageViewUtil {
  // 如果想定义新弹幕样式，可以再这里根据弹幕的类型来定义
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
    }

    return Text(model.content, style: TextStyle(color: Colors.white));
  }

  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          model.content,
          style: TextStyle(color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }
}
