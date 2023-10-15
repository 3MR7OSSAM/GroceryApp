import 'package:flutter/cupertino.dart';
import 'package:GroceryApp/services/Dark_prefs.dart';

class DarkThemeProvider with ChangeNotifier{
DarkPrefs DarkThemePrefs = DarkPrefs();
bool _darkTheme = false;
bool get getDarkTheme => _darkTheme;
set setDarkTheme(bool value){
  _darkTheme = value;
  DarkThemePrefs.setDarkTheme(value);
  notifyListeners();
}
}