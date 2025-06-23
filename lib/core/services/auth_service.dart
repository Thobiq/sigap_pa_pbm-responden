import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String _backendAuthApiUrl = 'http://192.168.1.2:3210/api/auth/pelapor-auth';

  static Future<String?> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return await userCredential.user?.getIdToken();
    } catch (e){
      print('error during google sign in : $e');
      return null;
    }
  }

  static Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try{
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      return await userCredential.user?.getIdToken();
    } on FirebaseAuthException catch (e){
      print('firebaseAuthException during sign up : ${e.code} - ${e.message}');
      rethrow;
    } catch (e){
      print('error during sign up to firebase $e');
      return null;
    }
  }

  static Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try{
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      return await userCredential.user?.getIdToken();
    } on FirebaseAuthException catch (e) {
      print('firebaseAuthException during sign in : $e');
      rethrow;
    } catch (e) {
      print('error during email/password sign in to firebase : $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendFirebaseTokenToBackend(String idToken) async {
    try{
      final response = await http.post(
        Uri.parse(_backendAuthApiUrl),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'idToken' : idToken,
        })
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('DEBUG : backend response body :$responseBody');
        final String? appToken = responseBody['token'];

        if (appToken != null){
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('app_jwt_token', appToken);
        }
        return responseBody;
      } else {
        print('backend api error : ${response.statusCode} - ${response.body}');
        return json.decode(response.body);
      }
    } catch (e) {
      print('error seeding token to backend $e');
      return {'success': false, 'message': 'koneksi ke server gagal'};
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_jwt_token');
  }

  static String getFirebaseAuthErrorMessage(String errorCode){
    switch (errorCode){
      case 'weak-password': return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use': return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
      case 'invalid-email': return 'Format email tidak valid.';
      case 'user-not-found': return 'Pengguna tidak ditemukan. Periksa email Anda.';
      case 'wrong-password': return 'Email atau password salah.';
      case 'network-request-failed': return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
      case 'too-many-requests': return 'Terlalu banyak percobaan login yang gagal. Coba lagi nanti.';
      default: return 'Terjadi kesalahan autentikasi yang tidak dikenal. $errorCode';
    }
  }
}