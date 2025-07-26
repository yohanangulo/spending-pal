import 'dart:io';

abstract class StorageService {
  Future<String> uploadProfileImage(File imageFile, String userId);
  Future<void> deleteProfileImage(String imageUrl);
}
