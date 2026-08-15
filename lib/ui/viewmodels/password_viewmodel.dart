import 'package:flutter/foundation.dart';
import '../../data/repositories/password_repository.dart';
import '../../domain/models/password_entry.dart';

class PasswordViewModel extends ChangeNotifier {
  final PasswordRepository _repository = PasswordRepository();

  List<PasswordEntry> _entries = [];
  List<PasswordEntry> get entries => _entries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entries = await _repository.getEntries(query: _searchQuery);
    } catch (e) {
      debugPrint('Error loading entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadEntries();
  }

  Future<void> addEntry({
    required String serviceName,
    required String username,
    required String plainPassword,
    String? notes,
  }) async {
    await _repository.addEntry(
      serviceName: serviceName,
      username: username,
      plainPassword: plainPassword,
      notes: notes,
    );
    await loadEntries();
  }

  Future<void> updateEntry({
    required String id,
    required String serviceName,
    required String username,
    required String plainPassword,
    String? notes,
    required DateTime createdAt,
  }) async {
    await _repository.updateEntry(
      id: id,
      serviceName: serviceName,
      username: username,
      plainPassword: plainPassword,
      notes: notes,
      createdAt: createdAt,
    );
    await loadEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    await loadEntries();
  }

  Future<String> decryptPassword(String encryptedPassword) async {
    return await _repository.decryptPassword(encryptedPassword);
  }
}
