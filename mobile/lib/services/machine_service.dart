import '../models/machine.dart';
import 'api_service.dart';

class MachineService {
  static Future<List<Machine>> getMachines() async {
    try {
      final response = await ApiService.get('/machines');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Machine.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Makineler yüklenemedi: ${e.toString()}');
    }
  }

  static Future<Machine?> getMachine(int id) async {
    try {
      final response = await ApiService.get('/machines/$id');
      if (response.statusCode == 200) {
        return Machine.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Makine bilgisi yüklenemedi: ${e.toString()}');
    }
  }

  static Future<Machine> createMachine({
    required String name,
    required int categoryId,
    String? description,
  }) async {
    try {
      final response = await ApiService.post('/machines', data: {
        'name': name,
        'category_id': categoryId,
        'description': description,
      });
      
      if (response.statusCode == 201) {
        return Machine.fromJson(response.data);
      }
      throw Exception('Makine oluşturulamadı');
    } catch (e) {
      throw Exception('Makine oluşturulamadı: ${e.toString()}');
    }
  }

  static Future<Machine> updateMachine({
    required int id,
    required String name,
    required int categoryId,
    String? description,
    String? status,
  }) async {
    try {
      final response = await ApiService.put('/machines/$id', data: {
        'name': name,
        'category_id': categoryId,
        'description': description,
        'status': status,
      });
      
      if (response.statusCode == 200) {
        return Machine.fromJson(response.data);
      }
      throw Exception('Makine güncellenemedi');
    } catch (e) {
      throw Exception('Makine güncellenemedi: ${e.toString()}');
    }
  }

  static Future<bool> deleteMachine(int id) async {
    try {
      final response = await ApiService.delete('/machines/$id');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Makine silinemedi: ${e.toString()}');
    }
  }

  static Future<List<Machine>> searchMachines(String query) async {
    try {
      final response = await ApiService.get('/machines', params: {
        'search': query,
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Machine.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Arama yapılamadı: ${e.toString()}');
    }
  }
}
