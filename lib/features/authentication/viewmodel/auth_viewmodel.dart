import 'package:flutter/material.dart';
import 'package:sigap_pa_pbm/core/services/auth_service.dart';
import 'package:sigap_pa_pbm/features/authentication/model/auth_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; 
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<AuthResponse?> signInWithGoogle() async {
    _setLoading(true);
    clearError();

    try {
      final String? idToken = await AuthService.signInWithGoogle();
      if (idToken == null) {
        _setError('Login Google dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }

      final Map<String, dynamic>? backendResponse =
          await AuthService.sendFirebaseTokenToBackend(idToken);

      if (backendResponse == null) {
        _setError('Koneksi ke backend gagal atau respons tidak valid.');
        return null;
      }

      final authResponse = AuthResponse.fromJson(backendResponse);
      if (!authResponse.success) {
        _setError(authResponse.message); 
      }
      return authResponse; 
    } catch (e) {
      _setError('Terjadi kesalahan saat login Google: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<AuthResponse?> signUpWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      final String? idToken = await AuthService.signUpWithEmailAndPassword(email, password);
      if (idToken == null) {
        _setError('Registrasi email/password dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }

      final Map<String, dynamic>? backendResponse =
          await AuthService.sendFirebaseTokenToBackend(idToken);

      if (backendResponse == null) {
        _setError('Koneksi ke backend gagal atau respons tidak valid.');
        return null;
      }

      final authResponse = AuthResponse.fromJson(backendResponse);
      if (!authResponse.success) {
        _setError(authResponse.message);
      }
      return authResponse;
    } on fb_auth.FirebaseAuthException catch (e) {
      _setError(AuthService.getFirebaseAuthErrorMessage(e.code));
      return null;
    } catch (e) {
      _setError('Terjadi kesalahan saat registrasi: ${e.toString()}'); 
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<AuthResponse?> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      final String? idToken = await AuthService.signInWithEmailAndPassword(email, password);
      if (idToken == null) {
        _setError('Login email/password dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }

      final Map<String, dynamic>? backendResponse =
          await AuthService.sendFirebaseTokenToBackend(idToken);

      if (backendResponse == null) {
        _setError('Koneksi ke backend gagal atau respons tidak valid.');
        return null;
      }

      final authResponse = AuthResponse.fromJson(backendResponse);
      if (!authResponse.success) {
        _setError(authResponse.message); 
      }
      return authResponse;
    } on fb_auth.FirebaseAuthException catch (e) {
      _setError(AuthService.getFirebaseAuthErrorMessage(e.code));
      return null;
    } catch (e) {
      _setError('Terjadi kesalahan saat login: ${e.toString()}'); 
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    await AuthService.signOut();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('app_jwt_token');
    return appToken != null && appToken.isNotEmpty;
  }
}