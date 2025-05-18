class UserProfile {
  final String name;
  final String id;
  final String role;
  final String email;
  final String phone;
  final String province;
  final String city;
  final String district;
  final String subdistrict;
  final String address;
  final String institusi;

  UserProfile({
    required this.name,
    required this.id,
    required this.role,
    required this.email,
    required this.phone,
    required this.province,
    required this.city,
    required this.district,
    required this.subdistrict,
    required this.address,
    required this.institusi,
  });

  // Factory constructor untuk parsing dari JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      subdistrict: json['subdistrict'] ?? '',
      address: json['address'] ?? '',
      institusi: json['institusi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'role': role,
      'email': email,
      'phone': phone,
      'province': province,
      'city': city,
      'district': district,
      'subdistrict': subdistrict,
      'address': address,
      'institusi': institusi,
    };
  }

  UserProfile copyWith({
    String? name,
    String? id,
    String? role,
    String? email,
    String? phone,
    String? province,
    String? city,
    String? district,
    String? subdistrict,
    String? address,
    String? institusi,
  }) {
    return UserProfile(
      name: name ?? this.name,
      id: id ?? this.id,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      address: address ?? this.address,
      institusi: institusi ?? this.institusi,
    );
  }
}
