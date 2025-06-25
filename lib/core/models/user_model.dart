// lib/core/models/user_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String firebaseUid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firebaseUid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    debugPrint('USER_MODEL: Parsing User.fromJson with raw JSON: $json');

    try {

      final parsedId = (json['id'] as int?) ?? 0; 
      
      final parsedFirebaseUid = (json['firebaseUid'] as String?) ?? 'UNKNOWN_FIREBASE_UID';
      
      final parsedEmail = (json['email'] as String?) ?? 'unknown@example.com';
      
      final parsedName = json['name'] as String?;
      final parsedPhoneNumber = json['phoneNumber'] as String?;
      final parsedAvatarUrl = json['avatarUrl'] as String?;
      
      final parsedRole = (json['role'] as String?) ?? 'pelapor'; 

      DateTime parsedCreatedAt;
      if (json['createdAt'] is String && json['createdAt'] != null) {
        try {
          parsedCreatedAt = DateTime.parse(json['createdAt'] as String);
        } catch (e) {
          debugPrint('USER_MODEL ERROR: Failed to parse createdAt string: ${json['createdAt']} due to $e. Using DateTime.now().');
          parsedCreatedAt = DateTime.now();
        }
      } else {
        debugPrint('USER_MODEL ERROR: createdAt is not a string or is null: ${json['createdAt']}. Using DateTime.now().');
        parsedCreatedAt = DateTime.now();
      }

      debugPrint('USER_MODEL: Parsed fields successfully. ID: $parsedId, FirebaseUID: $parsedFirebaseUid, Email: $parsedEmail, Name: $parsedName, Phone: $parsedPhoneNumber, Avatar: $parsedAvatarUrl, Role: $parsedRole, CreatedAt: $parsedCreatedAt');

      return User(
        id: parsedId,
        firebaseUid: parsedFirebaseUid,
        email: parsedEmail,
        name: parsedName,
        phoneNumber: parsedPhoneNumber,
        avatarUrl: parsedAvatarUrl,
        role: parsedRole,
        createdAt: parsedCreatedAt,
      );
    } catch (e) {
      debugPrint('USER_MODEL FATAL ERROR: Exception caught in User.fromJson. This is the root cause: $e');
      debugPrint('USER_MODEL FATAL ERROR: Raw JSON causing error: $json');
      rethrow; 
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid, 
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}