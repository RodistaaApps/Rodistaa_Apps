import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

/// Service class for handling all booking-related API calls
class BookingService {
  static const String baseUrl = 'https://api.rodistaa.com';

  /// Fetch all posted bookings
  /// GET /bookings/posted
  Future<List<Booking>> getPostedBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/posted'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posted bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posted bookings: $e');
      // Return mock data for demo purposes
      return _getMockPostedBookings();
    }
  }

  /// Fetch all confirmed bookings
  /// GET /bookings/confirmed
  Future<List<Booking>> getConfirmedBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/confirmed'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load confirmed bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching confirmed bookings: $e');
      // Return mock data for demo purposes
      return _getMockConfirmedBookings();
    }
  }

  /// Fetch detailed information for a specific booking
  /// GET /bookings/{bookingId}/details
  Future<BookingDetails> getBookingDetails(String bookingId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/$bookingId/details'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookingDetails.fromJson(jsonData);
      } else {
        throw Exception('Failed to load booking details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
      // Return mock data for demo purposes
      return _getMockBookingDetails(bookingId);
    }
  }

  /// Cancel a booking
  /// POST /bookings/{bookingId}/cancel
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to cancel booking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error cancelling booking: $e');
      // Simulate success for demo purposes
      return true;
    }
  }

  // Mock data for testing purposes
  List<Booking> _getMockPostedBookings() {
    return [
      Booking(
        id: '1',
        bookingId: 'RD001234',
        km: 45.0,
        pickup: 'Sector 18, Noida',
        drop: 'Connaught Place, Delhi',
        status: 'posted',
        createdAt: DateTime.now(),
      ),
      Booking(
        id: '2',
        bookingId: 'RD001235',
        km: 120.0,
        pickup: 'Gurgaon Cyber City',
        drop: 'Jaipur Railway Station',
        status: 'posted',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  List<Booking> _getMockConfirmedBookings() {
    return [
      Booking(
        id: '3',
        bookingId: 'RD001230',
        km: 85.0,
        pickup: 'Dwarka Sector 21',
        drop: 'Indira Gandhi Airport',
        status: 'confirmed',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  BookingDetails _getMockBookingDetails(String bookingId) {
    return BookingDetails(
      id: '1',
      bookingId: bookingId,
      km: 45.0,
      pickup: 'Sector 18, Noida',
      drop: 'Connaught Place, Delhi',
      status: 'posted',
      createdAt: DateTime.now(),
      truckType: 'Mini Truck',
      date: DateTime.now().add(const Duration(days: 1)),
      driverName: 'Rajesh Kumar',
      truckNumber: 'DL-1234',
      pickupAddress: 'Sector 18, Atta Market, Noida, UP 201301',
      dropAddress: 'Connaught Place, Central Delhi, Delhi 110001',
      estimatedCost: 2500.0,
      notes: 'Handle with care. Fragile items.',
    );
  }
}

