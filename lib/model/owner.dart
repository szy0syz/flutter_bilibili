class Owner {
  String name;
  String face;
  int fans;

  Owner({this.name, this.face, this.fans});

  //将map转成mo
  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }

  //将mo转成map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}
