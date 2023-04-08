import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static Future<bool> emailInfo() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    Future.delayed(Duration(microseconds: 1)).then((value) {
      if (!(spref.getBool('email_info') ?? false)) {
        spref.setBool('email_info', true);
      }
    });
    return spref.getBool('email_info') ?? false;
  }
}
