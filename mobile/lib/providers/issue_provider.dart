import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../services/api_service.dart';

class IssueProvider extends ChangeNotifier {
  List<Issue> _issues = [];
  bool _isLoading = false;
  String? _error;

  List<Issue> get issues => _issues;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchIssues() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/issues');
      if (response.data is List) {
        _issues = (response.data as List)
            .map((json) => Issue.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      print('Error fetching issues: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createIssue({
    required String title,
    required String description,
    required int machineId,
    required String priority,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/issues',
        data: {
          'title': title,
          'description': description,
          'machine_id': machineId,
          'priority': priority,
        },
      );

      if (response.statusCode == 201) {
        final newIssue = Issue.fromJson(response.data);
        _issues.insert(0, newIssue);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
      print('Error creating issue: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateIssueStatus(int issueId, String status) async {
    try {
      final response = await ApiService.put(
        '/issues/$issueId',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final updatedIssue = Issue.fromJson(response.data);
        final index = _issues.indexWhere((issue) => issue.id == issueId);
        if (index != -1) {
          _issues[index] = updatedIssue;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = e.toString();
      print('Error updating issue: $e');
    }
    return false;
  }
}
