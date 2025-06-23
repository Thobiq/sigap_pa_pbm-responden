class User{
  final int id;
  final String? firebaseUid;
  final String? email;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;
  final String role;
  // final DateTime createdAt;

  User({
    required this.id,
    this.firebaseUid,
    this.email,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    // required this.createdAt
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] as int,
      firebaseUid: json['firebaseUid'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String ?? 'pelapor',
      // createdAt: DateTime.parse(json['createdAt'] as String)
    );
  }
}