# Flutter Integration Guide - My Bookings Feature

## 🎯 Quick Integration Steps

If you have an existing Flutter app and want to add the My Bookings feature:

### Step 1: Copy Files

Copy these files to your project:

```
lib/
├── screens/
│   └── my_bookings_screen.dart
├── widgets/
│   ├── booking_card.dart
│   └── booking_details_modal.dart
├── models/
│   └── booking.dart
└── services/
    └── booking_service.dart
```

### Step 2: Add Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  intl: ^0.18.1
```

Then run:
```bash
flutter pub get
```

### Step 3: Update Navigation

Add to your bottom navigation bar:

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.receipt_long_outlined),
  activeIcon: Icon(Icons.receipt_long),
  label: 'My Bookings',
)
```

And in your screen list:

```dart
screens.add(MyBookingsScreen());
```

### Step 4: Configure API

Update `lib/services/booking_service.dart`:

```dart
static const String baseUrl = 'YOUR_API_BASE_URL';

// Add auth token in headers:
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $yourToken',
}
```

### Step 5: Run

```bash
flutter run
```

## 🎨 Customization

### Change Brand Color

Find and replace `Color(0xFFC90D0D)` with your brand color:

```dart
// In all widget files
const Color(0xFFC90D0D) → const Color(0xFFYOURCOLOR)
```

### Modify Card Design

Edit `lib/widgets/booking_card.dart`:

```dart
decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12.0), // Change radius
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), // Change shadow
      blurRadius: 6.0,
      offset: const Offset(0, 2),
    ),
  ],
)
```

### Adjust Modal Height

Edit `lib/widgets/booking_details_modal.dart`:

```dart
DraggableScrollableSheet(
  initialChildSize: 0.85, // Change initial height (0.0 to 1.0)
  minChildSize: 0.5,      // Minimum height
  maxChildSize: 0.95,     // Maximum height
)
```

## 📱 Standalone Testing

To test as a standalone app:

```bash
cd /home/rodistaa/New_Rodistaa_Apps
flutter pub get
flutter run
```

The app includes a complete navigation structure with Home, My Bookings, and Profile tabs.

## 🔄 API Integration

### Mock Data vs Real API

By default, the service falls back to mock data when API calls fail. This is great for testing!

To disable mock data for production:

```dart
// In booking_service.dart, remove the catch block fallback:

Future<List<Booking>> getPostedBookings() async {
  final response = await http.get(/*...*/);
  if (response.statusCode == 200) {
    // ... parse response
  } else {
    throw Exception('Failed to load');
  }
  // Remove: return _getMockPostedBookings();
}
```

### Authentication

Add token storage using `shared_preferences`:

```yaml
# pubspec.yaml
dependencies:
  shared_preferences: ^2.2.0
```

```dart
// In booking_service.dart
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

// Use in headers:
final token = await _getAuthToken();
headers: {
  'Content-Type': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
}
```

## 🧪 Testing Checklist

- [ ] Launch app
- [ ] Navigate to My Bookings tab
- [ ] Verify "Posted" tab is default
- [ ] Check booking cards display correctly
- [ ] Tap "View Details" → Modal opens
- [ ] Scroll modal content
- [ ] Close modal with X button
- [ ] Tap "Cancel" → Confirmation dialog appears
- [ ] Confirm cancellation
- [ ] Verify snackbar appears
- [ ] Pull down to refresh
- [ ] Switch to "Confirmed" tab
- [ ] Verify empty state (if no confirmed bookings)

## 🎯 Widget Documentation

### MyBookingsScreen

Main screen with tabs and booking lists.

**Parameters:** None

**Features:**
- TabBar with Posted/Confirmed tabs
- Pull-to-refresh
- Loading state
- Empty state
- App bar with refresh button

### BookingCard

Reusable card widget for displaying booking summary.

**Parameters:**
```dart
BookingCard({
  required Booking booking,      // Booking data model
  required VoidCallback onViewDetails,  // View details callback
  required VoidCallback onCancel,       // Cancel callback
  bool isLoading = false,        // Disable buttons when loading
})
```

### BookingDetailsModal

Bottom sheet modal for detailed booking information.

**Parameters:**
```dart
BookingDetailsModal({
  required String bookingId,     // Booking ID to fetch details
})
```

**Usage:**
```dart
showBookingDetailsModal(context, bookingId);
```

## 🔧 Advanced Configuration

### Custom Error Handling

Override error messages in `booking_service.dart`:

```dart
} catch (e) {
  // Custom error handling
  if (e is SocketException) {
    throw Exception('No internet connection');
  } else if (e is FormatException) {
    throw Exception('Invalid response format');
  } else {
    throw Exception('Something went wrong');
  }
}
```

### Add Loading Overlay

Wrap API calls with loading overlay:

```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => Center(
    child: CircularProgressIndicator(),
  ),
);

await _bookingService.cancelBooking(id);

Navigator.pop(context); // Close loading
```

### Custom Snackbar

Customize snackbar appearance:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: Color(0xFFC90D0D),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    margin: EdgeInsets.all(16),
    duration: Duration(seconds: 3),
  ),
);
```

## 📊 Performance Optimization

### ListView Optimization

The app already uses `ListView.builder` for efficient rendering, but you can add:

```dart
ListView.builder(
  itemCount: bookings.length,
  cacheExtent: 100, // Pre-render items
  addAutomaticKeepAlives: true,
  itemBuilder: (context, index) {
    // ...
  },
)
```

### Image Caching

If you add booking images:

```yaml
dependencies:
  cached_network_image: ^3.3.0
```

```dart
CachedNetworkImage(
  imageUrl: booking.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 🌐 Localization (Optional)

Add multiple language support:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

```dart
// Create l10n/app_en.arb, app_hi.arb, etc.
MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en', ''),
    Locale('hi', ''),
  ],
)
```

## 🐛 Common Issues

**Issue:** `intl` package errors
**Solution:**
```bash
flutter pub cache repair
flutter pub get
```

**Issue:** HTTP requests blocked on Android
**Solution:** Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true">
```

**Issue:** iOS network requests failing
**Solution:** Add to `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

**Need More Help?** Check the main README.md file!


