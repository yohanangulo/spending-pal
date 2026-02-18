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

  CategoryDto _fromFirestore(Map<String, dynamic> data) {
    final normalized = {...data};
    for (final key in normalized.keys) {
      if (normalized[key] is Timestamp) {
        normalized[key] = (normalized[key] as Timestamp).toDate().toIso8601String();
      }
    }
    return CategoryDto.fromJson(normalized);
  }

  @override
  Stream<List<CategoryDto>> watch() {
    return ref.where('userId', isEqualTo: currentUserId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList();
    });
  }

  @override
  Future<List<CategoryDto>> getCategories() async {
    final snapshot = await ref.where('userId', isEqualTo: currentUserId).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList();
  }

  @override
  Future<CategoryDto> upsert(CategoryDto categoryData) async {
    final json = categoryData.toJson();
    await ref.doc(categoryData.id).set(json);

    return categoryData;
  }

  @override
  Future<List<CategoryDto>> createCategories(List<CategoryDto> categoriesData) async {
    final batch = _firestore.batch();

    for (final data in categoriesData) {
      final json = data.toJson();
      batch.set(ref.doc(data.id), json);
    }

    await batch.commit();

    return categoriesData;
  }

  @override
  Future<void> updateCategory(CategoryDto category) async {
    final json = category.toJson();
    await ref.doc(category.id).update(json);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final query = await ref.where('id', isEqualTo: id).limit(1).get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'isDeleted': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Future<CategoryDto?> getCategoryById(String id) async {
    final doc = await ref.doc(id).get();

    if (doc.data() == null) return null;

    return _fromFirestore(doc.data()!);
  }

  @override
  Future<List<CategoryDto>> getUpdatedCategories([DateTime? lastUpdatedAt]) async {
    final snapshot = await ref
        .where('userId', isEqualTo: currentUserId)
        .where('updatedAt', isGreaterThan: lastUpdatedAt)
        .orderBy('updatedAt')
        .get();

    return snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList();
  }
}
