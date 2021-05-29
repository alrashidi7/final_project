import 'dart:io';

import 'package:flutter/material.dart';

class CheckConnection {
  Future<String> internetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return "done";
      } else {
        return 'error';
      }
    } on SocketException catch (_) {
      return 'error';
    }
  }
}
