import 'package:sigap_pa_pbm/core/models/user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.user
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json){
    return AuthResponse(
      success: json['success'] as bool, 
      message: json['message'] as String,
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null
    );
  }
}