import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyAlias = 'db_encryption_master_key';

  /// Mendapatkan atau membuat kunci AES-256 (32 bytes) dari Hardware-backed Keystore
  static Future<enc.Key> _getOrCreateMasterKey() async {
    String? existingKeyHex = await _storage.read(key: _keyAlias);
    if (existingKeyHex != null) {
      return enc.Key.fromBase64(existingKeyHex);
    }
    
    // Key 32 bytes (256-bit)
    final key = enc.Key.fromSecureRandom(32);
    await _storage.write(key: _keyAlias, value: key.base64);
    return key;
  }

  /// Dekripsi teks password menggunakan AES-256-CBC dengan random IV
  static Future<String> encryptText(String plainText) async {
    if (plainText.isEmpty) return '';
    final key = await _getOrCreateMasterKey();
    final iv = enc.IV.fromSecureRandom(16); // 128-bit random IV
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Simpan iv + payload terenkripsi dalam format "IV_BASE64:CIPHER_BASE64"
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Dekripsi teks terenkripsi menggunakan AES-256-CBC
  static Future<String> decryptText(String encryptedText) async {
    if (encryptedText.isEmpty) return '';
    final parts = encryptedText.split(':');
    if (parts.length != 2) return encryptedText; // Fallback jika format tidak sesuai

    final iv = enc.IV.fromBase64(parts[0]);
    final encryptedData = enc.Encrypted.fromBase64(parts[1]);

    final key = await _getOrCreateMasterKey();
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    return encrypter.decrypt(encryptedData, iv: iv);
  }

  /// Hash PIN Master dengan SHA-256 + Salt
  static String hashPin(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
