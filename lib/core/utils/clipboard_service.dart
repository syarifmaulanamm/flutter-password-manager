import 'dart:async';
import 'package:flutter/services.dart';

class ClipboardService {
  static Timer? _clearTimer;

  /// Copy text ke clipboard dan secara otomatis menghapusnya setelah [autoClearSeconds] detik
  static Future<void> copyToClipboard(String text, {int autoClearSeconds = 30}) async {
    await Clipboard.setData(ClipboardData(text: text));

    _clearTimer?.cancel();
    _clearTimer = Timer(Duration(seconds: autoClearSeconds), () async {
      final currentData = await Clipboard.getData(Clipboard.kTextPlain);
      if (currentData?.text == text) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    });
  }
}
