import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    // Demo hesaplar için local login
    if (email.endsWith('@test.com') && password == 'password') {
      return await _loginDemo(email);
    }

    try {
      final result = await AuthService.login(email, password);
      
      if (result['success']) {
        _user = result['user'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Backend bağlantısı yok. Demo hesapları kullanın.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> _loginDemo(String email) async {
    // Demo delay
    await Future.delayed(const Duration(milliseconds: 500));

    User? demoUser;
    
    switch (email) {
      case 'admin@test.com':
        demoUser = User(
          id: 1,
          name: 'Admin Kullanıcı',
          email: 'admin@test.com',
          role: 'admin',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );
        break;
      case 'operator@test.com':
        demoUser = User(
          id: 2,
          name: 'Operatör Kullanıcı',
          email: 'operator@test.com',
          role: 'operator',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now(),
        );
        break;
      case 'tech@test.com':
        demoUser = User(
          id: 3,
          name: 'Teknisyen Kullanıcı',
          email: 'tech@test.com',
          role: 'technician',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        );
        break;
      default:
        _setError('Geçersiz demo hesap');
        _setLoading(false);
        return false;
    }

    _user = demoUser;
    _setLoading(false);
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      
      if (result['success']) {
        _user = result['user'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Kayıt olurken hata oluştu');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await AuthService.logout();
    _user = null;
    _setLoading(false);
    notifyListeners();
  }

  Future<void> loadUser() async {
    _setLoading(true);
    try {
      final user = await AuthService.getCurrentUser();
      _user = user;
    } catch (e) {
      _user = null;
    }
    _setLoading(false);
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
