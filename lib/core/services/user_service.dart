import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _backendApiBaseUrl = 'http://192.168.1.2:3210/api';

  static Future<Map<String, dynamic>?> updatePelaporProfile({
    required String phoneNumber,
    String? name,
    String? avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? appToken = prefs.getString('app_jwt_token');

    if(appToken == null){
      print('error app token not found user not login');
      return null;
    }

    try{
      final response = await http.put(
        Uri.parse('$_backendApiBaseUrl/users/profile'),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $appToken',
        },
        body: jsonEncode(<String, String?>{
          'phoneNumber' : phoneNumber,
          'name' : name,
          'avatarUrl' : avatarUrl,
        })
      );

      if(response.statusCode == 200){
        return json.decode(response.body);
      } else{
        print('error update profile : ${response.statusCode} - ${response.body}');
        return json.decode(response.body);
      }
    } catch(e){
      print('exception during update profile : $e');
      return {'success': false, 'message' : 'koneksi ke server gagal'};
    }
  }
}