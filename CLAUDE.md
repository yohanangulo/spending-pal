# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SpendingPal is a Flutter expense tracking application built with Clean Architecture, BLoC state management, and Firebase backend. The app uses Drift for local database, supports multi-language (English/Spanish), and implements both dev and prod flavors.

## Development Commands

### Setup & Installation

```bash
# Install dependencies
flutter pub get

# Generate code (Freezed, Injectable, Drift, JsonSerializable)
make build

# Generate assets (images, icons, lottie)
dart run flutter_gen_runner

# Generate internationalization files
make intl
```

### Running the App

```bash
# Development flavor
flutter run --flavor dev -t lib/main_dev.dart

# Production flavor
flutter run --flavor prod -t lib/main_prod.dart
```

### Code Quality & Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run single test file
flutter test test/path/to/test_file.dart

# Analyze code
flutter analyze

# Clean project
make clean
```

## Architecture

### Clean Architecture Layers

The codebase follows Clean Architecture with a feature-based organization. Each feature domain (auth, categories, transaction, etc.) is structured into three layers:

**Domain Layer** (`lib/src/core/{feature}/src/domain/`)

- Entities (business models using Freezed)
- Repository interfaces (contracts)
- Failures (error handling with Freezed)
- Exported via `domain.dart` barrel file

**Application Layer** (`lib/src/core/{feature}/src/application/`)

- Use cases (optional - BLoCs can access repositories directly)
- Business logic operations
- Exported via `application.dart` barrel file

**Infrastructure Layer** (`lib/src/core/{feature}/src/infrastructure/`)

- Repository implementations
- Data sources (local and remote)
- DTOs (Data Transfer Objects using Freezed + JsonSerializable)
- Mappers (DTO ↔ Domain conversion)
- Database tables (Drift)
- Exported via `infrastructure.dart` barrel file

### Key Architectural Patterns

**State Management**: BLoC pattern with `flutter_bloc`

- BLoCs live in `lib/src/presentation/screens/{feature}/bloc/` or `lib/src/presentation/core/` for global state
- Events, States, and BLoC in separate files (uses `part`/`part of`)
- Use `@injectable` for dependency injection
- BLoCs can access repositories directly or optionally use use cases

**Dependency Injection**: `get_it` + `injectable`

- Configuration in `lib/src/config/service_locator/service_locator.dart`
- Use `@injectable`, `@lazySingleton`, `@singleton` annotations
- Run `dart run build_runner build` after adding new injectables

**Navigation**: `go_router`

- Routes defined in `lib/src/config/router/routes.dart`
- Router configuration in `lib/src/config/router/router.dart`
- Uses `MainStatefulShell` for bottom navigation

**Database**: Drift (type-safe SQLite)

- Main database: `lib/src/config/database/app_database.dart`
- Tables defined in feature infrastructure layer (e.g., `categories_table.dart`)
- After modifying tables, run `dart run build_runner build`

**Internationalization**:

- ARB files in `assets/l10n/`
- Generated code in `lib/src/config/translations/l10n/generated/`
- Access via `AppLocalizations.of(context)` or `context.l10n`

## Project Structure

```
lib/
├── main_dev.dart              # Dev flavor entry point
├── main_prod.dart             # Prod flavor entry point
└── src/
    ├── config/                # App-wide configuration
    │   ├── database/          # Drift database setup
    │   ├── router/            # Go Router navigation
    │   ├── service_locator/   # Dependency injection (get_it)
    │   ├── translations/      # i18n generated files
    │   └── extensions/        # Dart extensions
    ├── core/                  # Business logic (Clean Architecture)
    │   ├── auth/              # Authentication feature
    │   ├── categories/        # Category management
    │   ├── transaction/       # Transaction management
    │   ├── user/              # User profile
    │   └── common/            # Shared domain code
    └── presentation/          # UI layer
        ├── core/              # Global BLoCs (auth, theme, etc.)
        ├── screens/           # Feature screens
        ├── common/            # Reusable widgets
        └── splash/            # Splash screen

test/                          # Mirror structure of lib/
```

## Code Generation

This project heavily uses code generation. After modifying any of the following, run `dart run build_runner build`:

- `@freezed` classes (immutable models)
- `@injectable` classes (dependency injection)
- Drift tables (database)
- `@JsonSerializable` classes (DTOs)
- Database migrations (update `schemaVersion` in `app_database.dart`)

## Feature Development Pattern

When adding a new feature following the existing architecture:

1. **Domain Layer**: Define entities, repository interface, and failures
2. **Infrastructure Layer**: Implement repository, data sources (local/remote), DTOs, and mappers
3. **Application Layer**: Create use cases if needed (optional)
4. **Database**: Add Drift table if local storage needed
5. **Presentation**: Create screen with BLoC for state management
6. **Router**: Add route in `routes.dart` and configure in `router.dart`
7. **DI**: Ensure all classes are annotated with `@injectable` or equivalent
8. **Code Gen**: Run `dart run build_runner build`

## Important Conventions

- Use `Freezed` for all immutable classes (entities, DTOs, states, events, failures)
- Use `Equatable` for BLoC events and states if not using Freezed
- Prefer `final` for local variables (`prefer_final_locals` lint)
- Use single quotes for strings
- Line length: 120 characters
- Always use package imports, not relative imports
- DTOs use `@JsonSerializable`, domain entities do not
- Mappers convert between DTOs and domain entities
- Local data sources use Drift, remote use Firebase
- Repository implementations coordinate between local and remote sources

## Firebase Integration

- Auth: `firebase_auth` for user authentication
- Storage: `firebase_storage` for file uploads
- Firestore: `cloud_firestore` for remote data (used alongside Drift for local caching)

## Testing

Test files mirror the `lib/` structure in `test/` directory:

- Use `bloc_test` for testing BLoCs
- Use `mocktail` for mocking dependencies
- Test file naming: `{file_name}_test.dart`
