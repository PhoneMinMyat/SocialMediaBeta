import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class FlutterRemoteConfig {
  static final FlutterRemoteConfig _singleton = FlutterRemoteConfig._internal();

  factory FlutterRemoteConfig() {
    return _singleton;
  }

  FlutterRemoteConfig._internal(){
    initializeRemoteConfig();
    _remoteConfig.fetchAndActivate();
  }

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  void initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1)));
  }

  Color getThemeColorFromRemoteConfig(){
    String themeColorFromRemoteConfig = _remoteConfig.getString(remoteConfigThemeColor);
    print('Color From Remote Config ====> $themeColorFromRemoteConfig');

    return Color(int.parse(themeColorFromRemoteConfig));
  }

 
}
 const String remoteConfigThemeColor = 'theme_color';