import 'package:flutter/material.dart';
import 'package:sigap_pa_pbm/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sigap_pa_pbm/core/models/user_model.dart';
import 'package:location/location.dart'; 
import 'package:sigap_pa_pbm/core/services/emergency_report_service.dart';
import 'package:sigap_pa_pbm/core/routing/app_router.dart';
import 'package:sigap_pa_pbm/features/authentication/view/login_view.dart';

class HomeViewModel extends ChangeNotifier {
  String? _userEmail;
  String? _userName;
  String? _appToken;
  User? _currentUser;
  bool _isSendingSOS = false; 
  String? _sosErrorMessage; 

  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get appToken => _appToken;
  User? get currentUser => _currentUser;
  bool get isSendingSOS => _isSendingSOS;
  String? get sosErrorMessage => _sosErrorMessage;


  HomeViewModel() {
    loadUserDataAndToken();
  }

  Future<void> loadUserDataAndToken() async {
    debugPrint('HomeViewModel: Loading user data...');
    final prefs = await SharedPreferences.getInstance();
    _appToken = prefs.getString('app_jwt_token');
    debugPrint('HomeViewModel: App Token: $_appToken');

    final userJsonString = prefs.getString('current_user_data');
    debugPrint('HomeViewModel: User JSON from SharedPreferences: $userJsonString');

    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> userMap = json.decode(userJsonString) as Map<String, dynamic>;
        _currentUser = User.fromJson(userMap);
        // _currentUser = User.fromJson(json.decode(userJsonString));
        _userEmail = _currentUser?.email;
        _userName = _currentUser?.name;
        debugPrint('HomeViewModel: User data loaded from SharedPreferences: ${_currentUser?.email}');
      } catch (e) {
        debugPrint('HomeViewModel: Error parsing user data from SharedPreferences: $e');
        _currentUser = null;
      }
    } else {
      debugPrint('HomeViewModel: No user data found in SharedPreferences. Fetching from Firebase Auth...');
      final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _userEmail = firebaseUser.email;
        _userName = firebaseUser.displayName;
        debugPrint('HomeViewModel: User data from Firebase Auth: $_userEmail');
        
      } else {
        debugPrint('HomeViewModel: No user logged in via Firebase Auth either.');
      }
    }
    debugPrint('HomeViewModel: Notifying listeners. currentUser is: ${_currentUser?.email != null ? "NOT NULL" : "NULL"}');
    notifyListeners();
  }

  Future<bool> sendSOSReport() async {
    _setSendingSOS(true);
    clearSOSMessage(); 

    if (_currentUser == null) {
      _setSOSErrorMessage('Anda belum login. Silakan login terlebih dahulu.');
      _setSendingSOS(false);
      return false;
    }

    final Location location = Location();
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          _setSOSErrorMessage('Layanan lokasi tidak aktif.');
          return false;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          _setSOSErrorMessage('Izin lokasi ditolak.');
          return false;
        }
      }

      final LocationData currentLocation = await location.getLocation();
      if (currentLocation.latitude == null || currentLocation.longitude == null) {
        _setSOSErrorMessage('Gagal mendapatkan lokasi terkini.');
        return false;
      }

      const String reportType = 'kriminalitas'; 
      const String description = 'Laporan SOS Cepat!'; 
      
      final double lat = currentLocation.latitude!;
      final double lon = currentLocation.longitude!;

      final Map<String, dynamic>? response = await EmergencyReportService.createEmergencyReport(
        latitude: lat,
        longitude: lon,
        reportType: reportType,
        description: description,
        imageUrl: null, 
      );

      if (response != null && response['success'] == true) {
        _setSOSErrorMessage('Laporan SOS berhasil dikirim!'); 
        return true;
      } else {
        _setSOSErrorMessage(response?['message'] ?? 'Gagal mengirim laporan SOS.');
        return false;
      }

    } on fb_auth.FirebaseAuthException catch (e) {
      _setSOSErrorMessage(AuthService.getFirebaseAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setSOSErrorMessage('Terjadi kesalahan saat mengirim SOS: ${e.toString()}');
      return false;
    } finally {
      _setSendingSOS(false);
    }
  }

  void _setSendingSOS(bool value) {
    _isSendingSOS = value;
    notifyListeners();
  }

  void _setSOSErrorMessage(String? message) {
    _sosErrorMessage = message;
    notifyListeners();
  }
  
  void clearSOSMessage() {
    _sosErrorMessage = null;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await AuthService.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginView()),
      (Route<dynamic> route) => false,
    );
  }
}