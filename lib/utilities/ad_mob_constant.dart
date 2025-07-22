import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class AdMobConstant {
  // AdMob設定
  static String get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // Androidテスト用
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // iOSテスト用
      }
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-1225956609476984/3215872963';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-1225956609476984/8969217932';
      }
    }
    throw UnsupportedError('Unsupported platform');
  }
}
