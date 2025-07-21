import 'package:flutter/material.dart';

class DebugHelper {
  static void showDebugSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('DEBUG: $message'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static void logDebug(String tag, String message) {
    print('[$tag] $message');
  }
}
