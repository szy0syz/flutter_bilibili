import 'package:flutter/material.dart';
import 'package:flutter_bilibili/http/core/hi_error.dart';
import 'package:flutter_bilibili/http/dao/profile_dao.dart';
import 'package:flutter_bilibili/model/profile_mo.dart';
import 'package:flutter_bilibili/util/toast.dart';
import 'package:flutter_bilibili/util/view_util.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileMo? _profileMo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // 设置顶部扩展的可滚动高度
              expandedHeight: 160,
              // 标题栏是否固定
              pinned: true,
              // 定义滚动的空间
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 0),
                title: _buildTitle(),
                background: Container(color: Colors.deepOrangeAccent),
              ),
            )
          ];
        },
        body: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("标题$index"),
              );
            }),
      ),
    );
  }

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildTitle() {
    if (_profileMo == null) return Container();

    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(bottom: 30, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(_profileMo!.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(
            _profileMo!.name,
            style: TextStyle(fontSize: 11, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
