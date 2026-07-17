enum UserRole { farmer, buyer, admin }

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
  final String businessName;
  final String contactPerson;
  final String phoneNumber;
  final String? locationGps;
  final UserRole role;
  final bool isVetted;
  final double averageRating;
  final String preferredLang;

  AppUser({
    required this.id,
    required this.businessName,
    required this.contactPerson,
    required this.phoneNumber,
    this.locationGps,
    required this.role,
    this.isVetted = false,
    this.averageRating = 5.0,
    this.preferredLang = 'en',
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      businessName: map['business_name'] as String? ?? '',
      contactPerson: map['contact_person'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      locationGps: map['location_gps'] as String?,
      role: UserRoleX.fromString(map['user_role'] as String? ?? 'buyer'),
      isVetted: map['is_vetted'] as bool? ?? false,
      averageRating: (map['average_rating'] as num?)?.toDouble() ?? 5.0,
      preferredLang: map['preferred_lang'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'business_name': businessName,
      'contact_person': contactPerson,
      'phone_number': phoneNumber,
      'location_gps': locationGps,
      'user_role': role.value,
      'is_vetted': isVetted,
      'average_rating': averageRating,
      'preferred_lang': preferredLang,
    };
  }
}