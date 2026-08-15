import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/security/encryption_service.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _pinKey = 'master_pin_hash';
  static const _saltKey = 'master_pin_salt';

  /// Memeriksa apakah user sudah mendaftarkan Master PIN
  Future<bool> isPinSet() async {
    final pinHash = await _storage.read(key: _pinKey);
    return pinHash != null && pinHash.isNotEmpty;
  }

  /// Mendaftarkan Master PIN baru
  Future<void> setMasterPin(String pin) async {
    final salt = DateTime.now().millisecondsSinceEpoch.toString();
    final hashedPin = EncryptionService.hashPin(pin, salt);
    await _storage.write(key: _pinKey, value: hashedPin);
    await _storage.write(key: _saltKey, value: salt);
  }

  /// Verifikasi Master PIN saat Login
  Future<bool> verifyPin(String pin) async {
    final storedHash = await _storage.read(key: _pinKey);
    final storedSalt = await _storage.read(key: _saltKey);

    if (storedHash == null || storedSalt == null) return false;

    final inputHash = EncryptionService.hashPin(pin, storedSalt);
    return inputHash == storedHash;
  }
}
