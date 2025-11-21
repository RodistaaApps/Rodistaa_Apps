# Rodistaa Driver App

A production-ready Flutter mobile application designed for logistics drivers with a simple, intuitive UI optimized for users with varying levels of education.

## 🎨 Design Philosophy

- **Simple & Intuitive**: Clean interface with minimal text and clear visual hierarchy
- **Bold Icons**: Large, self-explanatory icons for easy navigation
- **High Contrast**: Easy-to-read text and clear color distinctions
- **Multilingual**: Support for 6 languages (English, Hindi, Telugu, Kannada, Malayalam, Tamil)

## 🎯 Features

### Authentication
- Mobile number login with OTP verification
- Smooth transitions between login states
- Auto-focus and auto-advance OTP input
- Resend OTP with countdown timer

### Home Screen
- Rotating banner carousel with auto-slide
- Quick stats (Total Deliveries, Today's Earnings)
- My Shipments card with active shipment count
- Pull-to-refresh functionality
- Bottom navigation bar

### Navigation
- Clean bottom navigation with 3 tabs (Home, My Shipments, Profile)
- Smooth page transitions
- Active tab highlighting

### Localization
- Support for 6 languages
- Language selector with native script display
- Persistent language preference

## 🛠️ Tech Stack

- **Flutter**: 3.x (latest stable)
- **State Management**: Provider
- **Routing**: GoRouter
- **Localization**: flutter_localizations
- **Typography**: Google Fonts (Poppins)
- **UI Components**: Material Design 3

## 📦 Dependencies

- `provider`: State management
- `go_router`: Navigation
- `flutter_localizations`: Multi-language support
- `google_fonts`: Beautiful typography
- `pin_code_fields`: OTP input
- `smooth_page_indicator`: Banner indicators
- `flutter_svg`: SVG image support
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd New_DriverUI_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```
   Note: Flutter automatically generates localization files when you run `flutter pub get` if `generate: true` is set in `pubspec.yaml`.

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── main.dart
├── config/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── routes/
│       └── app_routes.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── image_constants.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── language_provider.dart
│   └── utils/
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   └── login_screen.dart
│   │   └── widgets/
│   │       ├── language_selector.dart
│   │       ├── mobile_input_field.dart
│   │       └── otp_input_field.dart
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── banner_slider.dart
│   │       └── shipment_card.dart
│   ├── shipments/
│   │   └── screens/
│   │       └── my_shipments_screen.dart
│   └── profile/
│       └── screens/
│           └── profile_screen.dart
└── shared/
    └── widgets/
        └── custom_bottom_nav.dart

l10n/
├── app_en.arb
├── app_hi.arb
├── app_te.arb
├── app_kn.arb
├── app_ml.arb
└── app_ta.arb

assets/
├── images/
│   ├── banner_1.svg
│   └── banner_2.svg
└── icons/
```

## 🎨 Color Scheme

- **Primary Color**: #C90D0D (Red)
- **Secondary Color**: White
- **Background**: #F8F8F8 (Light Gray)
- **Text Primary**: #1A1A1A (Dark Gray)
- **Text Secondary**: #666666 (Medium Gray)

## 🌐 Supported Languages

1. **English** (en)
2. **Hindi** (hi) - हिंदी
3. **Telugu** (te) - తెలుగు
4. **Kannada** (kn) - ಕನ್ನಡ
5. **Malayalam** (ml) - മലയാളം
6. **Tamil** (ta) - தமிழ்

## 📱 Screens

### 1. Login Screen
- Mobile number input with country code (+91)
- OTP verification with 6-digit input
- Language selector
- Smooth state transitions

### 2. Home Screen
- Banner carousel with auto-slide
- Quick stats cards
- My Shipments card
- Pull-to-refresh

### 3. My Shipments Screen
- Empty state with icon
- List of active shipments (placeholder)

### 4. Profile Screen
- Driver profile information
- Settings, Help, Logout options

## 🔐 Authentication Flow

1. User enters mobile number
2. System sends OTP (mock implementation)
3. User enters 6-digit OTP
4. System verifies OTP (mock implementation)
5. User is authenticated and redirected to home screen

**Note**: Currently using mock authentication. Replace with actual API integration.

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 Code Style

- Follows Flutter style guide
- Uses `prefer_const_constructors` lint rule
- Consistent naming conventions
- Proper error handling
- Comprehensive comments

## 🐛 Known Issues

- Mock authentication (needs API integration)
- Placeholder screens for My Shipments and Profile
- SVG banners may need optimization for production

## 🔮 Future Enhancements

- [ ] API integration for authentication
- [ ] Real shipment data integration
- [ ] Push notifications
- [ ] Offline mode support
- [ ] Dark mode support
- [ ] Driver profile photo upload
- [ ] Real-time tracking
- [ ] Earnings dashboard
- [ ] Document upload
- [ ] Help & support chat

## 👥 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is proprietary and confidential.

## 📞 Support

For support, email support@rodistaa.com or create an issue in the repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Google Fonts for typography
- All open-source contributors

## 📋 Shipment Action Timeline Integration

- New UI lives in `lib/screens/shipment_action_panel.dart` with supporting widgets under `lib/widgets/`.
- Drop the experience into any screen through the existing `ShipmentActionsWidget` wrapper or by instantiating `ShipmentActionPanel`.
- Slide-to-confirm knobs automatically record timestamps, optional geo tags, and enqueue payloads through `QueueService.enqueue('status', shipmentId, payload)` for offline-first reliability.
- Contextual popups capture loading/unloading weights, advance amounts, and final payment details immediately after every slide.
- Colors, typography, and spacing match Rodistaa branding (primary red `#C90D0D`, Baloo Bhai for headings, Times New Roman for body text).

## 🚚 Shipments Module (Ongoing + Completed)

- `lib/screens/shipments_screen.dart` hosts the full experience with segmented filters (Ongoing, Completed, All), ConstrainedBox layout (max width 920px), skeleton loaders, pagination, and unified detail handling.
- `lib/widgets/shipment_card_final.dart` (ongoing) and `lib/widgets/completed_shipment_card.dart` (completed) render the canonical cards. Completed cards follow the QA reference stored at `assets/qa/completed_card_reference.png`.
- `lib/widgets/shipment_details_bottom_sheet.dart` supports read/write modes, OTP-less readonly states, Download Invoice, and Raise Issue flows via the new action buttons.
- `lib/services/shipment_api.dart` exposes stubbed hooks ready for backend wiring:
  - `fetchShipments({status, page, filters})`
  - `fetchShipmentDetails(shipmentId)`
  - `downloadInvoice(shipmentId)`
  - `raiseIssue(shipmentId, {subject, description, attachmentPath})`
  - `verifyOtp(...)` and `updateShipmentStatus(...)` for optimistic state updates
- Replace the stub implementations with real `GET /api/shipments`, `GET /api/shipments/:id`, `POST /api/shipments/:id/invoice`, and `POST /api/shipments/:id/issues` calls when integrating with the backend.
- Add visual QA checks by comparing cards against `assets/qa/completed_card_reference.png`. (The current file is a placeholder because the supplied `/mnt/data/...` path is not accessible on Windows—drop the official export in that location to keep comparisons accurate.)

---

**Built with ❤️ for Rodistaa Drivers**

