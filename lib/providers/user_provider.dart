import 'package:flutter/material.dart';
import 'package:nexa/models/user_model.dart';
import 'package:nexa/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedUser = await _repository.getUserById(userId);
      if (fetchedUser != null) {
        _user = fetchedUser;
      } else {
        _error = 'User no encontrado';
      }
    } catch (e) {
      _error = 'Error al cargar usuario';
      print('[User provider] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  bool isAdmin() {
    if (_user == null) return false;
    return _user!.isAdmin;
  }
}