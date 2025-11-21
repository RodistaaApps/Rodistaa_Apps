/// Model representing a saved address for pickup/drop locations.
class AddressModel {
  final String id;
  final String name;
  final String mobile;
  final String fullAddress;
  final double lat;
  final double lng;
  final DateTime createdAt;

  AddressModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.fullAddress,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  factory AddressModel.create({
    required String name,
    required String mobile,
    required String fullAddress,
    required double lat,
    required double lng,
  }) {
    return AddressModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      mobile: mobile,
      fullAddress: fullAddress,
      lat: lat,
      lng: lng,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'fullAddress': fullAddress,
        'lat': lat,
        'lng': lng,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      fullAddress: json['fullAddress'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

