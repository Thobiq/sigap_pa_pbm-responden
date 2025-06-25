import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  ProfileViewModel() {
  }

  Future<void> updateProfile({String? name, String? phoneNumber, String? avatarUrl}) async {
    _setLoading(true);
    clearError();
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      print('Profile update simulated: name=$name, phone=$phoneNumber, avatar=$avatarUrl');
    } catch (e) {
      _setError('Terjadi kesalahan saat memperbarui profil: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}