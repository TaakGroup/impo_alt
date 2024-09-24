import 'package:flutter/material.dart';
import 'package:social/features/messenger/data/models/user_info_model.dart';
import '../../../../features/share_experience/profile/data/models/profile_model.dart';
import '../../../app.dart';

class BoxHelper {
  static const _tokenKey = 'TOKEN';
  static const _profile = 'PROFILE';


  static void clearBox() => App.box.erase();

  // Save
  static Future<void> save(String kay, value) => App.box.write(kay, value);

  static read(String kay) => App.box.read(kay);

  // TOKEN
  static void setToken(String userToken) => App.box.write(_tokenKey, userToken);

  static void removeToken() => App.box.remove(_tokenKey);

  static String? get getToken => App.box.read(_tokenKey);

  static bool get hasToken => (App.box.read(_tokenKey) ?? '').isNotEmpty;

  // User
  static saveShareExperienceProfile(ProfileModel profile) => save(_profile, profile.toJson());

  static ProfileModel? get shareExperienceProfile {
    final json = read(_profile);
    return json != null ? ProfileModel().fromJson(json) : null;
  }
}
