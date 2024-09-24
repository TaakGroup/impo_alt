

import 'package:impo/src/core/app.dart';

class BoxHelper {
  static const _tokenKey = 'TOKEN';
  static const _userKey = 'USER';
  static const _password = 'PASSWORD';

  static void clearBox() => App.box.erase();

  // Save
  static Future<void> save(String kay, value) => App.box.write(kay, value);

  static read(String kay) => App.box.read(kay);

  // TOKEN
  static void setToken(String userToken) => App.box.write(_tokenKey, userToken);

  static void removeToken() => App.box.remove(_tokenKey);

  static String? get getToken => App.box.read(_tokenKey);

  static bool get hasToken => (App.box.read(_tokenKey) ?? '').isNotEmpty;

  // Local Auth
  static void setUser(String pass) => App.box.write(_userKey, pass);

  static void removeUser() => App.box.remove(_userKey);

  static String? get user => App.box.read(_userKey);

  static void setPassword(String pass) => App.box.write(_password, pass);

  static void removePassword() => App.box.remove(_password);

  static String? get password => App.box.read(_password);

}