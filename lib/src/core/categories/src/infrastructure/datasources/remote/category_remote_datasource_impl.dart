import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@LazySingleton(as: CategoryRemoteDatasource)
class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  CategoryRemoteDatasourceImpl(
    this._firestore,
    this._firebaseAuth,
  );

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  String get currentUserId => _firebaseAuth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get ref => _firestore.collection('categories');

  @override
  Stream<List<CategoryDto>> watch() {
    return ref.where('userId', isEqualTo: currentUserId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CategoryDto.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<List<CategoryDto>> getCategories() async {
    final snapshot = await ref.where('userId', isEqualTo: currentUserId).get();
    return snapshot.docs.map((doc) => CategoryDto.fromJson(doc.data())).toList();
  }

  @override
  Future<CategoryDto> createCategory(CategoryDto categoryData) async {
    await ref.doc(categoryData.id).set(categoryData.toJson());

    return categoryData;
  }

  @override
  Future<List<CategoryDto>> createCategories(List<CategoryDto> categoriesData) async {
    final batch = _firestore.batch();

    for (final data in categoriesData) {
      final newDoc = ref.doc(data.id);

      batch.set(newDoc, data.toJson());
    }

    await batch.commit();

    return categoriesData;
  }

  @override
  Future<void> updateCategory(CategoryDto category) async {
    await ref.doc(category.id).update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    final query = await ref.where('id', isEqualTo: id).limit(1).get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({'isDeleted': true});
    }
  }
}
