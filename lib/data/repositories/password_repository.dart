import 'package:uuid/uuid.dart';
import '../../core/security/encryption_service.dart';
import '../datasources/database_helper.dart';
import '../../domain/models/password_entry.dart';

class PasswordRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  Future<List<PasswordEntry>> getEntries({String query = ''}) async {
    if (query.trim().isEmpty) {
      return await _dbHelper.getAllEntries();
    } else {
      return await _dbHelper.searchEntries(query.trim());
    }
  }

  Future<void> addEntry({
    required String serviceName,
    required String username,
    required String plainPassword,
    String? notes,
  }) async {
    final encrypted = await EncryptionService.encryptText(plainPassword);
    final now = DateTime.now();

    final entry = PasswordEntry(
      id: _uuid.v4(),
      serviceName: serviceName,
      username: username,
      encryptedPassword: encrypted,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insert(entry);
  }

  Future<void> updateEntry({
    required String id,
    required String serviceName,
    required String username,
    required String plainPassword,
    String? notes,
    required DateTime createdAt,
  }) async {
    final encrypted = await EncryptionService.encryptText(plainPassword);
    final entry = PasswordEntry(
      id: id,
      serviceName: serviceName,
      username: username,
      encryptedPassword: encrypted,
      notes: notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );

    await _dbHelper.update(entry);
  }

  Future<void> deleteEntry(String id) async {
    await _dbHelper.delete(id);
  }

  Future<String> decryptPassword(String encryptedPassword) async {
    return await EncryptionService.decryptText(encryptedPassword);
  }
}
