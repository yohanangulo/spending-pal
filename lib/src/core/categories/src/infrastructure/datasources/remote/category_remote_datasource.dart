import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@lazySingleton
class CategoryRemoteDatasource {
  CategoryRemoteDatasource(
    this._firestore,
    this._firebaseAuth,
  );

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  String get currentUserId => _firebaseAuth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get ref => _firestore.collection('users/$currentUserId/categories');

  Stream<List<CategoryDto>> watch() {
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CategoryDto.fromJson(doc.data())).toList();
    });
  }

  Future<List<CategoryDto>> getCategories() async {
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => CategoryDto.fromJson(doc.data())).toList();
  }

  Future<CategoryDto> createCategory(CreateCategoryDto categoryData) async {
    final newDoc = ref.doc();

    final category = categoryData.copyWith(id: newDoc.id);
    await newDoc.set(category.toJson());

    return CategoryDto(
      id: newDoc.id,
      userId: categoryData.userId,
      name: categoryData.name,
      icon: categoryData.icon,
      color: categoryData.color,
    );
  }

  Future<List<CategoryDto>> createCategories(List<CreateCategoryDto> categoriesData) async {
    final batch = _firestore.batch();

    final List<CategoryDto> createdCategories = [];

    for (final data in categoriesData) {
      final newDoc = ref.doc();
      final category = data.copyWith(id: newDoc.id);

      batch.set(newDoc, category.toJson());

      createdCategories.add(
        CategoryDto(
          userId: data.userId,
          id: newDoc.id,
          name: data.name,
          icon: data.icon,
          color: data.color,
        ),
      );
    }

    await batch.commit();

    return createdCategories;
  }

  Future<void> updateCategory(Category category, String id) async {
    final dto = UpdateCategoryDto(
      color: category.color.toARGB32(),
      icon: category.icon.codePoint,
      name: category.name,
    );

    await ref.doc(id).update(dto.toJson());
  }

  Future<void> deleteCategory(String id) async {
    await ref.doc(id).delete();
  }
}
