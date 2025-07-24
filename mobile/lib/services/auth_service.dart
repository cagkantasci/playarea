import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post('/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['user']);
        
        await ApiService.setToken(token);
        
        return {
          'success': true,
          'user': user,
          'token': token,
        };
      }
      
      return {
        'success': false,
        'message': 'Giriş başarısız',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await ApiService.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
      
      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['user']);
        
        await ApiService.setToken(token);
        
        return {
          'success': true,
          'user': user,
          'token': token,
        };
      }
      
      return {
        'success': false,
        'message': 'Kayıt başarısız',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  static Future<void> logout() async {
    try {
      await ApiService.post('/logout');
    } catch (e) {
      // Ignore logout errors
    }
    await ApiService.clearToken();
  }

  static Future<User?> getCurrentUser() async {
    try {
      final response = await ApiService.get('/user');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      // User is not authenticated
    }
    return null;
  }
}
