import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isPinSet = false;
  bool get isPinSet => _isPinSet;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> checkPinState() async {
    _isPinSet = await _repository.isPinSet();
    notifyListeners();
  }

  Future<bool> setupPin(String newPin) async {
    if (newPin.length < 4) {
      _errorMessage = 'PIN minimal harus 4 digit';
      notifyListeners();
      return false;
    }
    await _repository.setMasterPin(newPin);
    _isPinSet = true;
    _isAuthenticated = true;
    _errorMessage = '';
    notifyListeners();
    return true;
  }

  Future<bool> login(String pin) async {
    final isValid = await _repository.verifyPin(pin);
    if (isValid) {
      _isAuthenticated = true;
      _errorMessage = '';
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Master PIN salah!';
      notifyListeners();
      return false;
    }
  }

  void lockApp() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
