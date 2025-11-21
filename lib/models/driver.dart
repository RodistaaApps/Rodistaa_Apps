class Driver {
  Driver({
    required this.driverId,
    required this.name,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.licenseType,
    required this.licenseExpiry,
    this.assignedTruckId,
    this.assignedTruckNumber,
    required this.experienceYears,
    required this.status,
    required this.address,
    this.photo,
    required this.joiningDate,
    List<String>? documents,
  }) : documents = documents ?? <String>[];

  final String driverId;
  final String name;
  final String phoneNumber;
  final String licenseNumber;
  final String licenseType;
  final DateTime licenseExpiry;
  String? assignedTruckId;
  String? assignedTruckNumber;
  int experienceYears;
  String status;
  final String address;
  final String? photo;
  final DateTime joiningDate;
  final List<String> documents;

  Driver copyWith({
    String? driverId,
    String? name,
    String? phoneNumber,
    String? licenseNumber,
    String? licenseType,
    DateTime? licenseExpiry,
    String? assignedTruckId,
    String? assignedTruckNumber,
    int? experienceYears,
    String? status,
    String? address,
    String? photo,
    DateTime? joiningDate,
    List<String>? documents,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseType: licenseType ?? this.licenseType,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      assignedTruckId: assignedTruckId ?? this.assignedTruckId,
      assignedTruckNumber: assignedTruckNumber ?? this.assignedTruckNumber,
      experienceYears: experienceYears ?? this.experienceYears,
      status: status ?? this.status,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      joiningDate: joiningDate ?? this.joiningDate,
      documents: documents ?? List<String>.from(this.documents),
    );
  }
}

