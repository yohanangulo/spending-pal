import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/storage/domain/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: StorageService)
class StorageServiceImpl implements StorageService {
  StorageServiceImpl(
    this._supabase,
  );

  final SupabaseClient _supabase;

  @override
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    final fileName = 'user-pictures/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final StorageFileApi sfapi = _supabase.storage.from('app-users');

    await sfapi.upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(contentType: 'image/*'),
    );

    return _supabase.storage.from('app-users').getPublicUrl(fileName);
  }

  @override
  Future<void> deleteProfileImage(String imageUrl) async {
    final fileName = imageUrl.split('/').last;
    await _supabase.storage.from('app-users').remove(['user-pictures/$fileName']);
  }
}
