import 'package:flutter/material.dart';
import '../models/machine.dart';
import '../services/machine_service.dart';

class MachineProvider with ChangeNotifier {
  List<Machine> _machines = [];
  Machine? _selectedMachine;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Machine> get machines => _machines;
  Machine? get selectedMachine => _selectedMachine;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Machine> get filteredMachines {
    if (_searchQuery.isEmpty) {
      return _machines;
    }
    return _machines.where((machine) =>
      machine.name.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadMachines() async {
    _setLoading(true);
    _setError(null);

    try {
      _machines = await MachineService.getMachines();
      _setLoading(false);
    } catch (e) {
      // Backend bağlantısı yoksa demo veriler kullan
      _machines = _getDemoMachines();
      _setLoading(false);
    }
  }

  List<Machine> _getDemoMachines() {
    return [
      Machine(
        id: 1,
        name: 'CNC Torna Tezgahı 1',
        categoryId: 1,
        categoryName: 'Torna',
        description: 'Hassas işleme için CNC torna tezgahı',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Machine(
        id: 2,
        name: 'Freze Makinesi A',
        categoryId: 2,
        categoryName: 'Freze',
        description: 'Dikey freze makinesi',
        status: 'maintenance',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Machine(
        id: 3,
        name: 'Kaynak Makinesi B',
        categoryId: 3,
        categoryName: 'Kaynak',
        description: 'MIG/MAG kaynak makinesi',
        status: 'inactive',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Machine(
        id: 4,
        name: 'Pres Makinesi 1',
        categoryId: 4,
        categoryName: 'Pres',
        description: 'Hidrolik pres makinesi',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Machine(
        id: 5,
        name: 'Tornalama Tezgahı 2',
        categoryId: 1,
        categoryName: 'Torna',
        description: 'Manuel torna tezgahı',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  Future<void> loadMachine(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedMachine = await MachineService.getMachine(id);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> createMachine({
    required String name,
    required int categoryId,
    String? description,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final newMachine = await MachineService.createMachine(
        name: name,
        categoryId: categoryId,
        description: description,
      );
      _machines.add(newMachine);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateMachine({
    required int id,
    required String name,
    required int categoryId,
    String? description,
    String? status,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedMachine = await MachineService.updateMachine(
        id: id,
        name: name,
        categoryId: categoryId,
        description: description,
        status: status,
      );
      
      final index = _machines.indexWhere((m) => m.id == id);
      if (index != -1) {
        _machines[index] = updatedMachine;
      }
      
      if (_selectedMachine?.id == id) {
        _selectedMachine = updatedMachine;
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteMachine(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await MachineService.deleteMachine(id);
      if (success) {
        _machines.removeWhere((m) => m.id == id);
        if (_selectedMachine?.id == id) {
          _selectedMachine = null;
        }
        notifyListeners();
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _setError(null);
  }

  void clearSelectedMachine() {
    _selectedMachine = null;
    notifyListeners();
  }
}
