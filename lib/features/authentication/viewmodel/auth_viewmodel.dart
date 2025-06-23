import 'package:flutter/material.dart';
import 'package:sigap_pa_pbm/core/services/auth_service.dart';
import 'package:sigap_pa_pbm/features/authentication/model/auth_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    clearError(); // Bersihkan error sebelumnya

    try {
      final String? idToken = await AuthService.signInWithGoogle(); // Panggil AuthService
      if (idToken != null) {
        final Map<String, dynamic>? backendResponse =
            await AuthService.sendFirebaseTokenToBackend(idToken); // Kirim ke backend

        if (backendResponse != null) {
          final authResponse = AuthResponse.fromJson(backendResponse);
          if (!authResponse.success) {
            _setError(authResponse.message); // Set error jika backend bilang gagal
          }
          return authResponse; // Kembalikan respons dari backend (sukses/gagal)
        } else {
          // Kasus jika AuthService.sendFirebaseTokenToBackend mengembalikan null
          _setError('Koneksi ke backend gagal atau respons tidak valid.');
          return null;
        }
      } else {
        // Kasus jika login Google dibatalkan atau gagal di Firebase
        _setError('Login Google dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }
    } catch (e) {
      // Tangkap error umum lainnya
      _setError('Terjadi kesalahan saat login Google: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false); // Selalu set loading ke false di akhir
    }
  }

  Future<AuthResponse?> signUpWithEmailAndPassword(
      String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      final String? idToken = await AuthService.signUpWithEmailAndPassword(email, password);
      if (idToken != null) {
        final Map<String, dynamic>? backendResponse =
            await AuthService.sendFirebaseTokenToBackend(idToken);

        if (backendResponse != null) {
          final authResponse = AuthResponse.fromJson(backendResponse);
          if (!authResponse.success) {
            _setError(authResponse.message);
          }
          return authResponse;
        } else {
          _setError('Koneksi ke backend gagal atau respons tidak valid.');
          return null;
        }
      } else {
        _setError('Registrasi email/password dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Tangkap error spesifik dari Firebase Auth
      _setError(AuthService.getFirebaseAuthErrorMessage(e.code));
      return null;
    } catch (e) {
      _setError('Terjadi kesalahan saat registrasi: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<AuthResponse?> signInWithEmailAndPassword(
      String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      final String? idToken = await AuthService.signInWithEmailAndPassword(email, password);
      if (idToken != null) {
        final Map<String, dynamic>? backendResponse =
            await AuthService.sendFirebaseTokenToBackend(idToken);

        if (backendResponse != null) {
          final authResponse = AuthResponse.fromJson(backendResponse);
          if (!authResponse.success) {
            _setError(authResponse.message); // Jika backend bilang gagal
          }
          // Ini adalah baris KUNCI: jika sukses, kembalikan authResponse
          return authResponse;
        } else {
          _setError('Koneksi ke backend gagal atau respons tidak valid.');
          return null;
        }
      } else {
        _setError('Login email/password dibatalkan atau terjadi kesalahan di Firebase.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
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
    // Navigasi ke AuthScreen akan dilakukan di View, bukan di ViewModel
    // Karena ViewModel tidak boleh tahu tentang konteks UI (Navigator)
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