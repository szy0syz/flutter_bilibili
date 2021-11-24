
import 'package:flutter_test/flutter_test.dart';
import 'package:hi_cache/hi_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('测试HiCache', () async {
    //fix ServiceBinding
    TestWidgetsFlutterBinding.ensureInitialized();
    //fix MssingPluginException
    SharedPreferences.setMockInitialValues({});

    var key = "testHiCache", value = "Hello";
    await HiCache.getInstance().setString(key, value);

    expect(HiCache.getInstance().get(key), value);
  });
}