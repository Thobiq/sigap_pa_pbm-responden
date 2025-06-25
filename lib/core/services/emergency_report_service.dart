import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyReportService {
  static const String _backendApiBaseUrl = 'http://192.168.190.118:3210/api';

  static Future<Map<String, dynamic>?> createEmergencyReport({
    required double latitude,
    required double longitude,
    required String reportType,
    String? description,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? appToken = prefs.getString('app_jwt_token');

    if(appToken == null){
      print('error app token not found');
      return {'success': false, 'message': 'silahkan login kembali'};
    }

    print('EmergencyReportService: Sending report with token: $appToken');

    try{
      final response = await http.post(
        Uri.parse('$_backendApiBaseUrl/reports'),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $appToken',
        },
        body: jsonEncode(<String, dynamic>{
          'latitude' : latitude,
          'longitude' : longitude,
          'reportType' : reportType,
          'description' : description,
          'imageUrl' : imageUrl,
        }),
      );

      if(response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('api erro creating report ${response.statusCode} - ${response.body}');
        return json.decode(response.body);
      }
    } catch (e){
      print('exception creating report $e');
      return {'success': false, 'message':'koneksi ke server gagal'};
    }

  }
}