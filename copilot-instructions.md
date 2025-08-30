# Flutter Project Architecture Guidelines

## Project Structure
- Follow feature-first organization with `lib/features/[feature]/`
- Each feature contains data, domain, and presentation layers

## State Management
- Use BLoC/Cubit pattern for state management
- Events and states should be defined for each feature
- Use `Equatable` for state comparison

## Clean Architecture
- **Presentation Layer**: UI components, widgets, BLoC/Cubit
- **Domain Layer**: Business logic, entities, repository interfaces
- **Data Layer**: Repository implementations, data sources, models

## Code Standards
- Use PascalCase for class names
- Use camelCase for variables and functions
- Follow effective Dart style guide
- Implement proper error handling

## Dependencies
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `dio` for API calls
- `isar` for local database
- `go_router` for navigation

## Project Setup
1. Navigate to the project directory:
   ```bash
   cd raja_c_flutter_employees
   ```
2. Create a new Flutter project:
   ```bash
   flutter create --platforms android .
   ```
3. Update `pubspec.yaml` to include necessary dependencies:
   ```bash
   flutter pub add dartz
   ```
   ```yaml
   dependencies:
     flutter_bloc: ^8.0.0
     get_it: ^7.0.0
     dio: ^5.0.0
     isar: ^3.0.0
     go_router: ^6.0.0
   ```
4. Run `flutter pub get` to install the dependencies.
   ```
   flutter clean
   flutter pub get
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```