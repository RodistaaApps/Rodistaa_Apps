class OperatorProfile {
  final String operatorId;
  final String name;
  final String phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final String? profilePhotoUrl;
  final String streetAddress;
  final String city;
  final String state;
  final String pinCode;
  final String? companyName;
  final String? gstNumber;
  final String? panNumber;
  final bool kycVerified;
  final String? aadhaarNumber;
  final DateTime? kycVerifiedDate;
  final DateTime createdAt;
  final DateTime lastUpdated;

  OperatorProfile({
    required this.operatorId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.profilePhotoUrl,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.pinCode,
    this.companyName,
    this.gstNumber,
    this.panNumber,
    required this.kycVerified,
    this.aadhaarNumber,
    this.kycVerifiedDate,
    required this.createdAt,
    required this.lastUpdated,
  });

  String get fullAddress {
    return '$streetAddress, $city, $state - $pinCode';
  }

  OperatorProfile copyWith({
    String? operatorId,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? dateOfBirth,
    String? profilePhotoUrl,
    String? streetAddress,
    String? city,
    String? state,
    String? pinCode,
    String? companyName,
    String? gstNumber,
    String? panNumber,
    bool? kycVerified,
    String? aadhaarNumber,
    DateTime? kycVerifiedDate,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return OperatorProfile(
      operatorId: operatorId ?? this.operatorId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      companyName: companyName ?? this.companyName,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      kycVerified: kycVerified ?? this.kycVerified,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      kycVerifiedDate: kycVerifiedDate ?? this.kycVerifiedDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory OperatorProfile.fromJson(Map<String, dynamic> json) {
    return OperatorProfile(
      operatorId: json['operatorId'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth'] as String) : null,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      streetAddress: json['streetAddress'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pinCode: json['pinCode'] as String,
      companyName: json['companyName'] as String?,
      gstNumber: json['gstNumber'] as String?,
      panNumber: json['panNumber'] as String?,
      kycVerified: json['kycVerified'] as bool? ?? false,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      kycVerifiedDate: json['kycVerifiedDate'] != null ? DateTime.tryParse(json['kycVerifiedDate'] as String) : null,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(json['lastUpdated'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operatorId': operatorId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profilePhotoUrl': profilePhotoUrl,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'companyName': companyName,
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'kycVerified': kycVerified,
      'aadhaarNumber': aadhaarNumber,
      'kycVerifiedDate': kycVerifiedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
