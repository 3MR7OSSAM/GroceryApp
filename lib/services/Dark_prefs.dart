import 'package:shared_preferences/shared_preferences.dart';

class DarkPrefs{
  static const THEME_STATUS = "THEME_STATUS";

    setDarkTheme(bool value) async {
      SharedPreferences prerfs = await SharedPreferences.getInstance();
      prerfs.setBool(THEME_STATUS, value);
    }
    Future<bool> getTheme () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getBool(THEME_STATUS) ?? false;
    }
    }
