import 'dart:io';

 import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
class DeviceInfo {
  String? identifier;

  Future<String?> getDeviceDetails() async {

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      identifier = build.androidId;
      print('checking  $identifier');
      identifier?.replaceAll("[a-z]","");
      // String? replace;
      var replace=identifier?.replaceAll(RegExp(r'[a-zA-Z.]'), '');
      print('identifier: $replace');
//UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor; //UUID for iOS
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
//if (!mounted) return;
  return identifier?.replaceAll(RegExp(r'[a-zA-Z.]'), '');
}
}
