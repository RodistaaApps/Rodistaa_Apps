# Rodistaa Operator App - My Bookings Feature

A Flutter application featuring a comprehensive "My Bookings" screen with Posted/Confirmed tabs and detailed booking information modal.

## 🚀 Features

### ✅ My Bookings Screen
- **Two-Tab Interface**: Posted and Confirmed bookings
- **Default Tab**: Opens on "Posted" by default
- **Pull-to-Refresh**: Swipe down to refresh booking lists
- **Real-time Updates**: Automatic refresh after booking cancellation

### ✅ Booking Cards
- Clean, modern card design with soft shadows
- Displays: Booking ID, Distance (KM), Pickup/Drop locations
- Two action buttons:
  - **View Details** (outlined red)
  - **Cancel** (solid red with confirmation dialog)

### ✅ Booking Details Modal
- Smooth slide-up bottom sheet animation
- Rounded top corners with dimmed background
- Comprehensive information display:
  - Booking ID with status badge
  - Distance, Truck Type, Date, Estimated Cost
  - Driver Name and Truck Number
  - Full pickup and drop addresses
  - Additional notes (if available)
- Loading state with progress indicator
- Error handling with retry button

### ✅ API Integration
- **GET** `/bookings/posted` - Fetch posted bookings
- **GET** `/bookings/confirmed` - Fetch confirmed bookings
- **GET** `/bookings/{id}/details` - Fetch booking details
- **POST** `/bookings/{id}/cancel` - Cancel booking
- Fallback to mock data for testing

## 📱 Screenshots

```
┌─────────────────────────────┐
│  🧾 My Bookings        🔄   │
├─────────────────────────────┤
│  Posted (2) │ Confirmed (1) │ ← Tabs
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ ID: RD001234      45 KM │ │
│ │ 📍 Pickup: Sector 18    │ │
│ │ 📍 Drop: CP, Delhi      │ │
│ │ [View Details] [Cancel] │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ ID: RD001235     120 KM │ │
│ │ ...                     │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point with navigation
├── screens/
│   └── my_bookings_screen.dart        # Main bookings screen with tabs
├── widgets/
│   ├── booking_card.dart              # Reusable booking card widget
│   └── booking_details_modal.dart     # Details modal bottom sheet
├── models/
│   └── booking.dart                   # Data models (Booking, BookingDetails)
└── services/
    └── booking_service.dart           # API service layer
```

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Step 1: Install Dependencies

```bash
cd /home/rodistaa/New_Rodistaa_Apps
flutter pub get
```

### Step 2: Run the App

```bash
flutter run
```

Or use your IDE's run button.

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0          # HTTP client for API calls
  intl: ^0.18.1         # Date formatting
  cupertino_icons: ^1.0.2
```

## 🔧 Configuration

### Update API Base URL

Edit `lib/services/booking_service.dart`:

```dart
static const String baseUrl = 'https://api.rodistaa.com';
```

### Add Authentication Token

In `lib/services/booking_service.dart`, add your auth token:

```dart
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer YOUR_TOKEN_HERE',
}
```

## 🎨 Design System

### Colors
- **Brand Red**: `Color(0xFFC90D0D)` - Primary buttons, active states
- **White**: Card backgrounds
- **Gray Shades**: Text hierarchy (black87, grey, grey.shade400)

### Shadows
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 6.0,
  offset: Offset(0, 2),
)
```

### Spacing
- Card padding: `16.0`
- Section spacing: `12.0` - `24.0`
- Consistent use of `EdgeInsets.all()` and `SizedBox`

### Typography
- **Title**: 20.0, bold
- **Body**: 14.0 - 16.0, regular/medium
- **Caption**: 12.0, gray

## 📱 Usage

### Navigation Integration

The My Bookings screen is integrated into the bottom navigation:

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.receipt_long_outlined),
  activeIcon: Icon(Icons.receipt_long),
  label: 'My Bookings',
)
```

### Programmatic Navigation

```dart
Navigator.pushNamed(context, '/myBookings');
```

## 🧪 Testing

### Mock Data
The app includes mock data that activates when API calls fail:

**Posted Bookings:**
- RD001234: Sector 18, Noida → Connaught Place, Delhi (45 KM)
- RD001235: Gurgaon Cyber City → Jaipur Railway Station (120 KM)

**Confirmed Bookings:**
- RD001230: Dwarka Sector 21 → Indira Gandhi Airport (85 KM)

### Testing Flow
1. Launch app → Navigate to "My Bookings" tab
2. View default "Posted" bookings
3. Switch to "Confirmed" tab
4. Tap "View Details" on any booking
5. Review detailed information in modal
6. Close modal and tap "Cancel" button
7. Confirm cancellation in dialog
8. Pull down to refresh list

## 🔐 API Response Format

### Booking List
```json
[
  {
    "id": "1",
    "bookingId": "RD001234",
    "km": 45,
    "pickup": "Sector 18, Noida",
    "drop": "Connaught Place, Delhi",
    "status": "posted",
    "createdAt": "2025-11-05T10:30:00Z"
  }
]
```

### Booking Details
```json
{
  "id": "1",
  "bookingId": "RD001234",
  "km": 45,
  "pickup": "Sector 18, Noida",
  "drop": "Connaught Place, Delhi",
  "status": "posted",
  "createdAt": "2025-11-05T10:30:00Z",
  "truckType": "Mini Truck",
  "date": "2025-11-06T09:00:00Z",
  "driverName": "Rajesh Kumar",
  "truckNumber": "DL-1234",
  "pickupAddress": "Sector 18, Atta Market, Noida, UP 201301",
  "dropAddress": "Connaught Place, Central Delhi, Delhi 110001",
  "estimatedCost": 2500,
  "notes": "Handle with care. Fragile items."
}
```

## 🐛 Troubleshooting

### Issue: Dependencies not resolving
```bash
flutter clean
flutter pub get
```

### Issue: API calls failing
- Check network connectivity
- Verify API endpoint URLs
- App automatically falls back to mock data for testing

### Issue: Build errors
```bash
flutter doctor
flutter clean
flutter pub get
flutter run
```

## 🎯 Key Features Checklist

- ✅ Two tabs: Posted & Confirmed
- ✅ Default to Posted tab
- ✅ Booking cards with all required fields
- ✅ View Details button (outlined red)
- ✅ Cancel button (solid red)
- ✅ Confirmation dialog before cancel
- ✅ Bottom sheet modal with smooth animation
- ✅ Rounded corners and dimmed background
- ✅ Comprehensive booking details display
- ✅ Loading states with CircularProgressIndicator
- ✅ Error handling with retry button
- ✅ Pull-to-refresh functionality
- ✅ Snackbar notifications
- ✅ Empty state designs
- ✅ Responsive layout
- ✅ Clean code structure with reusable widgets
- ✅ Null safety enabled
- ✅ API integration with HTTP package

## 📝 Code Quality

- ✅ Stateless and Stateful widgets properly used
- ✅ FutureBuilder for async operations
- ✅ Try-catch error handling
- ✅ Separation of concerns (Models, Services, Widgets, Screens)
- ✅ Comprehensive comments
- ✅ Consistent naming conventions
- ✅ Material Design guidelines

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📞 Support

For issues or questions, refer to the Flutter documentation:
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart API Reference](https://api.dart.dev/)

## 🎉 What's Next?

Potential enhancements:
- [ ] Search and filter functionality
- [ ] Date range picker for bookings
- [ ] Push notifications
- [ ] Offline support with local database
- [ ] Dark mode
- [ ] Booking history analytics

---

**Built with ❤️ using Flutter for Rodistaa**


