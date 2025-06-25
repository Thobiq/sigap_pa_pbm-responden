import 'package:http/http.dart' as http; 
import 'package:image_picker/image_picker.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'dart:convert'; 
import 'dart:io'; 

class UploadService {
  static const String _uploadApiUrl = 'http://192.168.190.118:3210/api/upload/image';

  static Future<XFile?> pickImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source, imageQuality: 80);
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<String?> uploadImage(XFile imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final String? appToken = prefs.getString('app_jwt_token'); 

    if (appToken == null) {
      print('UploadService Error: App token not found. User not logged in.');
      return null; 
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(_uploadApiUrl));
      
      request.headers['Authorization'] = 'Bearer $appToken';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          imageFile.path, 
          filename: imageFile.name, 
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UploadService: Backend Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody['url'] as String?; 
      } else {
        print('UploadService Error: Upload failed with status ${response.statusCode}: ${response.body}');
        return null; // Gagal upload
      }
    } catch (e) {
      print('UploadService Exception: Error during image upload: $e');
      return null;
    }
  }
}