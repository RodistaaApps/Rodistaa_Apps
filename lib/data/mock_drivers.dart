import 'package:rodistaa_operator_app/models/driver.dart';

final List<Driver> mockDrivers = [
  Driver(
    driverId: 'D001',
    name: 'Raju Kumar',
    phoneNumber: '+91 98765 43210',
    licenseNumber: 'KA1234567890123',
    licenseType: 'HMV',
    licenseExpiry: DateTime(2026, 5, 12),
    assignedTruckId: 'T001',
    assignedTruckNumber: 'KA-01-AB-1234',
    experienceYears: 6,
    status: 'onTrip',
    address: 'Bangalore, Karnataka',
    joiningDate: DateTime(2022, 4, 2),
  ),
  Driver(
    driverId: 'D002',
    name: 'Suresh Reddy',
    phoneNumber: '+91 87654 32109',
    licenseNumber: 'TS9876543210123',
    licenseType: 'HTV',
    licenseExpiry: DateTime(2025, 12, 20),
    experienceYears: 8,
    status: 'available',
    address: 'Hyderabad, Telangana',
    joiningDate: DateTime(2021, 7, 15),
  ),
  Driver(
    driverId: 'D003',
    name: 'Mohd Faizal',
    phoneNumber: '+91 91234 56780',
    licenseNumber: 'KA9081726354012',
    licenseType: 'HMV',
    licenseExpiry: DateTime(2024, 12, 31),
    experienceYears: 5,
    status: 'onLeave',
    address: 'Mysuru, Karnataka',
    joiningDate: DateTime(2020, 10, 1),
  ),
];

