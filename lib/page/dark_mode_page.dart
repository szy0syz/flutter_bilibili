import 'package:flutter/material.dart';
import 'package:flutter_bilibili/provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  DarkModePage({Key? key}) : super(key: key);

  @override
  _DarkModePageState createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const _ITEMS = [
    {"name": '跟随系统', "mode": ThemeMode.system},
    {"name": '开启', "mode": ThemeMode.dark},
    {"name": '关闭', "mode": ThemeMode.light},
  ];

  var _currentTheme;

  @override
  void initState() {
    super.initState();
    var themeMode = context.read<ThemeProvider>().getThemeMode();
    _ITEMS.forEach((element) {
      if (element["mode"] == themeMode) {
        _currentTheme = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('夜间模式')),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _item(index);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: _ITEMS.length),
    );
  }

  Widget _item(int index) {
    var theme = _ITEMS[index];

    return InkWell(
      onTap: () {
        _switchTheme(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text(theme["name"] as String)),
            Opacity(
              opacity: _currentTheme == theme ? 1 : 0,
              child: Icon(Icons.done, color: primary),
            )
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme  = _ITEMS[index];
    context.read<ThemeProvider>();

    setState(() {
      _currentTheme = theme;
    });
  }
}
