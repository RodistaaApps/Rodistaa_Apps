# Rodistaa User Login - Frontend Files

This folder contains all the frontend UI files related to the Rodistaa user login page created on November 3, 2025.

## Folder Structure

```
rodistaauserlogin/
├── ui/                          # UI widgets
│   ├── login_screen.dart        # Main login screen with header and card
│   ├── login_card.dart          # Login card with phone input and OTP
│   ├── header_section.dart      # Header with Rodistaa branding and language selector
│   └── otp_input.dart           # OTP input widget with 4 boxes
├── providers/                   # State management
│   ├── auth_provider.dart       # Authentication state and OTP flow logic
│   └── language_provider.dart   # Multi-language support and translations
├── services/                    # Business logic
│   └── auth_service.dart        # Mock OTP service (returns true for OTP: 1234)
├── assets/                      # Static assets
│   └── images/
│       ├── top_illustration.svg # Background illustration for header
│       ├── top_illustration.png # PNG version of illustration
│       └── rodistaa_logo.png    # Rodistaa logo
└── README.md                    # This file
```

## UI Components

### 1. Login Screen (`login_screen.dart`)
- Main entry point for the login page
- Contains the header section and login card
- Uses red (#C90D0D) background for branding

### 2. Login Card (`login_card.dart`)
- White elevated card with phone number input
- India flag icon with +91 country code
- OTP verification section
- Send OTP and Login buttons
- Timer and Resend OTP functionality

### 3. Header Section (`header_section.dart`)
- Displays Rodistaa branding
- Language selector pill (supports 6 languages)
- Background illustration with decorative pattern
- Uses Google Fonts (Baloo Bhai 2)

### 4. OTP Input (`otp_input.dart`)
- 4-box OTP input with auto-advance
- Supports paste functionality for 4-digit codes
- Backspace navigation between boxes

## Dependencies

These files depend on the following Flutter packages:
- `flutter/material.dart` - Material design widgets
- `provider` - State management
- `google_fonts` - Custom fonts

## Providers (State Management)

### 1. Auth Provider (`auth_provider.dart`)
- Manages authentication state
- Handles phone validation (10 digits)
- Sends and resends OTP
- 60-second countdown timer
- OTP verification (mock: accepts "1234")

### 2. Language Provider (`language_provider.dart`)
- Manages app language/locale
- Supports 6 languages: English, Hindi, Tamil, Kannada, Telugu, Malayalam
- Provides translations for UI text

## Services

### 1. Auth Service (`auth_service.dart`)
- Mock OTP service (for demo purposes)
- Simulates sending OTP
- **Test OTP Code: 1234** (hardcoded for demo)
- In production, would connect to real API

## ⚠️ Important Notes

### This is a REFERENCE COPY
- These files are **copied** from `/home/rodistaa/lib/`
- The **original files remain in your main project** at `/home/rodistaa/` 
- Your Flutter project at `/home/rodistaa/` needs those original files to run
- This folder is for **reference, backup, or reuse** purposes only

### To Run This Login Page
You would need to also include:
- `main.dart` with proper Provider setup
- `pubspec.yaml` with dependencies (provider, google_fonts, etc.)
- `assets/fonts/` folder with custom fonts
- Home screen to navigate to after login

### Design Details
- Brand color: #C90D0D (Rodistaa red)
- Supports 6 Indian languages
- OTP-based phone authentication (+91)
- 60-second resend timer
- Fully responsive mobile design

