# Axion - Cycling Tracker App 🚴‍♂️

A modern Flutter-based cycling tracking application that helps users monitor their cycling routes, track performance, and manage their cycling activities with a beautiful dark-themed UI.

## 📱 Screenshots

<div align="center">
  <img src="Simulator Screenshot - iPhone 16 Plus - 2025-08-20 at 19.32.42.png" width="300" alt="Welcome Screen">
  <img src="Simulator Screenshot - iPhone 16 Plus - 2025-08-20 at 19.35.18.png" width="300" alt="Home Screen">
  <img src="Simulator Screenshot - iPhone 16 Plus - 2025-08-20 at 19.39.22.png" width="300" alt="Map Screen">
</div>

## 📄 Documentation

For detailed project documentation and specifications, see: [Axion.pdf](Axion.pdf)

## ✨ Features

- **🗺️ Interactive Map**: Real-time location tracking with multiple map styles
- **📊 Route Tracking**: Record and save cycling routes with detailed analytics
- **📈 Performance Analytics**: Track distance, time, and cycling statistics
- **🔐 User Authentication**: Firebase-based login and registration system
- **🌙 Dark Theme**: Beautiful dark UI optimized for outdoor use
- **📱 Cross-Platform**: Runs on both iOS and Android
- **🔋 Battery Optimization**: Smart battery saving mode for long rides
- **📍 Location Services**: Precise GPS tracking with permission management

## 🏗️ Architecture

The app follows a clean architecture pattern with feature-based organization:

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants.dart       # App-wide constants and colors
│   └── roatename.dart      # Route definitions
├── features/               # Feature modules
│   ├── home2_feature/      # Home screen and dashboard
│   ├── login_feature/      # Authentication
│   ├── map_feature/        # Map and tracking
│   ├── signup_feature/     # User registration
│   ├── setting_feature/    # App settings
│   └── splash_feature/     # Splash screen
└── main.dart              # App entry point
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.6.1+
- **State Management**: GetX
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Maps**: Flutter Map with OpenStreetMap
- **Location**: Geolocator & Location packages
- **Charts**: FL Chart for analytics
- **UI**: Material Design with custom theming

## 📦 Dependencies

### Core Dependencies

- `flutter`: SDK
- `get`: ^4.6.5 - State management
- `firebase_core`: ^3.10.1 - Firebase integration
- `firebase_auth`: ^5.4.1 - Authentication
- `cloud_firestore`: ^5.6.2 - Database
- `geolocator`: ^13.0.2 - Location services
- `flutter_map`: ^7.0.2 - Interactive maps

### UI & Visualization

- `google_fonts`: ^6.2.1 - Typography
- `lottie`: ^3.3.0 - Animations
- `fl_chart`: ^0.70.1 - Charts and graphs
- `flutter_svg`: ^2.0.17 - SVG support

### Utilities

- `shared_preferences`: ^2.3.4 - Local storage
- `permission_handler`: ^11.3.1 - Permissions
- `battery_plus`: ^6.2.1 - Battery monitoring
- `http`: ^1.3.0 - Network requests

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.6.1 or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase project setup

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/axion.git
   cd axion
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Run `flutterfire configure` to set up Firebase options

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Configuration

1. Enable Authentication with Email/Password and Google Sign-In
2. Set up Firestore database with appropriate security rules
3. Configure Firebase Storage for route data

### Map Configuration

The app uses multiple map tile providers. You can customize map styles in `lib/core/constants.dart`:

```dart
var mapLinks = <String>[
  'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
  'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  // Add more map providers as needed
];
```

## 📱 App Flow

1. **Splash Screen** - App initialization and Firebase setup
2. **Authentication** - Login/Register with email or Google
3. **Email Verification** - Verify email before accessing main features
4. **Home Dashboard** - View cycling statistics and saved routes
5. **Map Tracking** - Start/stop cycling sessions with real-time tracking
6. **Route Management** - Save, view, and delete cycling routes

## 🎨 UI/UX Features

- **Dark Theme**: Optimized for outdoor cycling conditions
- **Responsive Design**: Adapts to different screen sizes
- **Smooth Animations**: Enhanced user experience with Lottie animations
- **Intuitive Navigation**: GetX-based routing system
- **Custom Fonts**: Lato and Poppins for better readability

## 🔒 Permissions

The app requires the following permissions:

- **Location**: For GPS tracking during cycling
- **Storage**: For saving route data and images
- **Network**: For Firebase sync and map tiles
- **Battery Optimization**: For background tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions, please open an issue on GitHub or contact the development team.

---

**Happy Cycling! 🚴‍♂️**
