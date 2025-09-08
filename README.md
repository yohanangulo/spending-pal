# 💰 SpendingPal

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

**A modern, feature-rich expense tracking mobile application built with Flutter**

_Helping you take control of your finances with beautiful design and powerful features_

[![Flutter Version](https://img.shields.io/badge/Flutter-3.4.4+-blue)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-Private-red)](#)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)](#)

</div>

---

<div align="center">

## 📱 App Preview

|                                                   Login - Dashboard Screen                                                   |                                                      Categories Screen                                                       |
| :--------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------: |
| <img width="275" src="https://github.com/user-attachments/assets/e9d8383f-5e9a-4171-8a17-398ea5f4b6c0" alt="Login Screen" /> | <img width="275" src="https://github.com/user-attachments/assets/8943e20e-9724-4f89-be69-62bdc332a609" alt="Login Screen" /> |

</div>

---

## 🌟 Overview

SpendingPal is a comprehensive personal finance management application designed to help users track their expenses, manage categories, and gain insights into their spending habits. Built with modern Flutter development practices, it showcases advanced mobile app development skills including clean architecture, state management, and real-time data synchronization.

## ✨ Key Features

### 📊 **Expense Management**

- 📝 Add, edit, and delete expenses with ease
- 🏷️ Categorize expenses for better organization
- 📅 Track spending over time with detailed history

### 🎯 **Category System**

- 📂 Create custom spending categories
- 🎨 Visual category management with intuitive UI
- 📈 Category-based spending analytics

### 🔐 **Authentication & Security**

- 🚪 Secure user authentication with Firebase Auth
- 👤 User profile management
- 🔒 Privacy and security settings

### 🌍 **Internationalization**

- 🌐 Multi-language support (English, Spanish)
- 🎯 Localized content and formatting
- 📱 Adaptive UI for different regions

### 🎨 **Modern UI/UX**

- 🌙 Dark/Light theme support
- 🎭 Smooth animations with Lottie
- 📱 Responsive design for all screen sizes
- 🎯 Intuitive navigation with Go Router

## 🛠️ Tech Stack & Architecture

### **Frontend**

- **Flutter** - Cross-platform mobile development
- **Dart** - Primary programming language
- **BLoC Pattern** - State management with flutter_bloc
- **Go Router** - Navigation and routing

### **Backend & Storage**

- **Firebase Auth** - User authentication
- **Firebase Storage** - File and media storage
- **Drift** - Local SQLite database with type safety
- **Shared Preferences** - Local key-value storage

### **Architecture Pattern**

- **Clean Architecture** - Separation of concerns with layers
- **Domain-Driven Design** - Business logic separation
- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - Using get_it and injectable

### **Development Tools**

- **Code Generation** - Freezed for immutable classes
- **Testing** - Unit tests with bloc_test and mocktail
- **Linting** - Flutter lints for code quality
- **Asset Generation** - flutter_gen for type-safe assets

## 📱 Screens & Features

| Screen                | Description                       | Status            |
| --------------------- | --------------------------------- | ----------------- |
| 🏠 **Overview**       | Dashboard with spending summary   | ✅ Implemented    |
| 🔐 **Authentication** | Login/Register with Firebase      | ✅ Implemented    |
| 📂 **Categories**     | Manage expense categories         | ✅ Implemented    |
| 💰 **Expenses**       | Add and track expenses            | 🚧 In Development |
| 📊 **Dashboard**      | Analytics and insights            | 🚧 In Development |
| ⚙️ **Settings**       | App preferences and configuration | ✅ Implemented    |
| 👤 **Profile**        | User account management           | ✅ Implemented    |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.4.4+)
- Dart SDK
- Android Studio / Xcode
- Firebase project setup

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/spending_pal.git
   cd spending_pal
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code**

   ```bash
   dart run build_runner build
   ```

4. **Configure Firebase**

   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration

5. **Run the app**

   ```bash
   # Development
   flutter run --flavor dev -t lib/main_dev.dart

   # Production
   flutter run --flavor prod -t lib/main_prod.dart
   ```

## 🏗️ Project Structure

```
lib/
├── main_dev.dart                 # Development entry point
├── main_prod.dart               # Production entry point
└── src/
    ├── config/                  # App configuration
    │   ├── database/           # Database setup
    │   ├── router/             # Navigation
    │   └── service_locator/    # Dependency injection
    ├── core/                   # Business logic
    │   ├── auth/              # Authentication domain
    │   ├── categories/        # Category management
    │   └── common/            # Shared utilities
    └── presentation/          # UI layer
        ├── common/            # Shared UI components
        ├── screens/           # App screens
        └── core/              # UI state management
```

## 🧪 Testing

Run the test suite:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🔧 Development Commands

```bash
# Code generation
dart run build_runner build

# Asset generation
dart run flutter_gen_runner

# Internationalization
flutter gen-l10n
```

## 📈 Performance & Quality

- **🎯 Clean Architecture** - Maintainable and testable codebase
- **🔧 Type Safety** - Leveraging Dart's strong typing with Freezed
- **📊 State Management** - Predictable state with BLoC pattern
- **🚀 Performance** - Optimized with proper widget lifecycle management
- **🧪 Testing** - Comprehensive unit and widget tests

## 🤝 Contributing

This is a portfolio project, but suggestions and feedback are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 👨‍💻 Developer

**Yohan Angulo** - _Mobile Developer_

- 📧 [your.email@example.com](mailto:your.email@example.com)
- 🔗 [LinkedIn](https://linkedin.com/in/yourprofile)
- 🐙 [GitHub](https://github.com/yourusername)

---

<div align="center">

**Built with ❤️ using Flutter**

_Showcasing modern mobile development practices and clean architecture principles_

</div>
