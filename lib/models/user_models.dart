enum UserRole { farmer, buyer }

extension UserRoleX on UserRole {
  String get value => name;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (r) => r.value == value,
      orElse: () => UserRole.buyer,
    );
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? businessName;
  final String? location;
  final bool verified;
  final bool profileComplete;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.businessName,
    this.location,
    this.verified = false,
    this.profileComplete = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      role: UserRoleX.fromString(map['role'] as String? ?? 'buyer'),
      businessName: map['business_name'] as String?,
      location: map['location'] as String?,
      verified: map['verified'] as bool? ?? false,
      profileComplete: map['profile_complete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.value,
      'business_name': businessName,
      'location': location,
      'verified': verified,
      'profile_complete': profileComplete,
    };
  }
}