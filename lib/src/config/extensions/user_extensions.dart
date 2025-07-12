part of 'extensions.dart';

extension UserExtensions on User {
  String get userDisplayName => displayName ?? 'User';
}
