// ignore_for_file: file_names

import 'dart:io';
import 'package:connectivity/connectivity.dart';

class InternetCheck {
  // Return true if internet is available, else, return false.
  static Future<bool> checkInternet() async {
    // Check si on est connecté en wifi ou en donnée mobile.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    }

    // Check si il est possible de capter internet.
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
