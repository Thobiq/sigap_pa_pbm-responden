import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc_pkg; 
import 'package:image_picker/image_picker.dart'; 
import 'package:sigap_pa_pbm/core/services/emergency_report_service.dart'; 
import 'package:sigap_pa_pbm/core/services/upload_service.dart'; 
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; 

class ReportEmergencyViewModel extends ChangeNotifier {
  String _selectedReportType = 'kriminalitas'; 
  final List<String> _reportTypes = [
    'kebakaran', 'kecelakaan', 'medis', 'kriminalitas', 'bencana alam', 'lainnya'
  ]; 

  loc_pkg.LocationData? _currentLocation; 
  bool _isGettingLocation = false; 
  bool _isUploadingProof = false; 
  XFile? _selectedProofFile; 
  String? _uploadedImageUrl; 

  bool _isSendingReport = false; 
  String? _errorMessage; 
  String? _successMessage; 

  String get selectedReportType => _selectedReportType;
  List<String> get reportTypes => _reportTypes;
  loc_pkg.LocationData? get currentLocation => _currentLocation;
  bool get isGettingLocation => _isGettingLocation;
  bool get isUploadingProof => _isUploadingProof;
  XFile? get selectedProofFile => _selectedProofFile;
  String? get uploadedImageUrl => _uploadedImageUrl;
  bool get isSendingReport => _isSendingReport;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;


  ReportEmergencyViewModel() {
    _getCurrentLocation(); 
  }

  void setSelectedReportType(String type) {
    _selectedReportType = type;
    notifyListeners();
  }

  void _setGettingLocation(bool value) {
    _isGettingLocation = value;
    notifyListeners();
  }

  void _setUploadingProof(bool value) {
    _isUploadingProof = value;
    notifyListeners();
  }

  void _setSendingReport(bool value) {
    _isSendingReport = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    _successMessage = null; 
    notifyListeners();
  }

  void _setSuccessMessage(String? message) {
    _successMessage = message;
    _errorMessage = null; 
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }


  Future<void> _getCurrentLocation() async {
    _setGettingLocation(true);
    clearMessages(); 

    final loc_pkg.Location location = loc_pkg.Location();
    try {
      bool _serviceEnabled;
      loc_pkg.PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          _setErrorMessage('Layanan lokasi tidak aktif atau tidak diizinkan.');
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc_pkg.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc_pkg.PermissionStatus.granted) {
          _setErrorMessage('Izin lokasi ditolak. Mohon izinkan akses lokasi.');
          return;
        }
      }

      _currentLocation = await location.getLocation();
      if (_currentLocation?.latitude == null || _currentLocation?.longitude == null) {
        _setErrorMessage('Gagal mendapatkan koordinat lokasi.');
        _currentLocation = null; 
        return;
      }
      _setSuccessMessage('Lokasi berhasil didapatkan.');
    } catch (e) {
      _setErrorMessage('Terjadi kesalahan saat mendapatkan lokasi: ${e.toString()}');
      _currentLocation = null;
    } finally {
      _setGettingLocation(false);
    }
  }

  Future<void> pickAndUploadProof({required ImageSource source}) async {
    _setUploadingProof(true);
    clearMessages();

    try {
      final XFile? pickedFile = await UploadService.pickImage(source: source);
      if (pickedFile == null) {
        _setErrorMessage('Pemilihan file dibatalkan.');
        return;
      }
      
      _selectedProofFile = pickedFile;
      notifyListeners(); 

      _setSuccessMessage('Mengunggah bukti...');
      final String? imageUrl = await UploadService.uploadImage(pickedFile);

      if (imageUrl == null) {
        _setErrorMessage('Gagal mengunggah bukti. Coba lagi.');
        return;
      }

      _uploadedImageUrl = imageUrl;
      _setSuccessMessage('Bukti berhasil diunggah.');

    } catch (e) {
      _setErrorMessage('Terjadi kesalahan saat mengunggah bukti: ${e.toString()}');
      _uploadedImageUrl = null;
    } finally {
      _setUploadingProof(false);
    }
  }

  Future<bool> sendEmergencyReport({required String description}) async {
    _setSendingReport(true);
    clearMessages();

    if (_currentLocation?.latitude == null || _currentLocation?.longitude == null) {
      _setErrorMessage('Lokasi belum tersedia. Mohon coba lagi dapatkan lokasi.');
      _setSendingReport(false);
      return false;
    }
    if (description.trim().isEmpty) {
      _setErrorMessage('Deskripsi laporan tidak boleh kosong.');
      _setSendingReport(false);
      return false;
    }

    try {
      debugPrint('REPORT_VM: Payload imageUrl: $_uploadedImageUrl');
      final Map<String, dynamic>? response = await EmergencyReportService.createEmergencyReport(
        latitude: _currentLocation!.latitude!,
        longitude: _currentLocation!.longitude!,
        reportType: _selectedReportType,
        description: description,
        imageUrl: _uploadedImageUrl, 
      );

      if (response != null && response['success'] == true) {
        _setSuccessMessage('Laporan darurat berhasil dikirim!');
        _resetForm();
        return true;
      } else {
        _setErrorMessage(response?['message'] ?? 'Gagal mengirim laporan darurat.');
        return false;
      }

    } catch (e) {
      _setErrorMessage('Terjadi kesalahan saat mengirim laporan: ${e.toString()}');
      return false;
    } finally {
      _setSendingReport(false);
    }
  }

  void _resetForm() {
    _selectedReportType = 'kriminalitas';
    _currentLocation = null;
    _selectedProofFile = null;
    _uploadedImageUrl = null;
    notifyListeners();
    _getCurrentLocation(); 
  }

  void refreshLocation() {
    _getCurrentLocation();
  }
}