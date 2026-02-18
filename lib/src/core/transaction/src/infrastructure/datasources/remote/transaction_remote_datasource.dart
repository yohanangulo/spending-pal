import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/dto/transaction_dto.dart';

abstract class TransactionRemoteDatasource {
  Future<void> create(TransactionDto transaction);
  Future<void> update(TransactionDto transaction);
  Future<void> delete(String id);
  Future<TransactionDto?> getById(String id);
  Stream<List<TransactionDto>> watchUserTransactions(String userId);
  Future<List<TransactionDto>> getUserTransactions(String userId);
  Future<void> upsert(TransactionDto transaction);
  Future<List<TransactionDto>> getUpdatedTransactions([DateTime? lastUpdatedAt]);
}

@LazySingleton(as: TransactionRemoteDatasource)
class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  const TransactionRemoteDatasourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  String get currentUserId => _firebaseAuth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('transactions');

  TransactionDto _fromFirestore(Map<String, dynamic> data) {
    final normalized = {...data};

    for (final key in normalized.keys) {
      if (normalized[key] is Timestamp) {
        normalized[key] = (normalized[key] as Timestamp).toDate().toIso8601String();
      }
    }

    return TransactionDto.fromJson(normalized);
  }

  @override
  Future<void> create(TransactionDto transaction) async {
    final json = transaction.toJson();
    await _collection.doc(transaction.id).set(json);
  }

  @override
  Future<void> update(TransactionDto transaction) async {
    final json = transaction.toJson();
    await _collection.doc(transaction.id).update(json);
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<TransactionDto?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc.data()!);
  }

  @override
  Stream<List<TransactionDto>> watchUserTransactions(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList());
  }

  @override
  Future<List<TransactionDto>> getUserTransactions(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).orderBy('date', descending: true).get();

    return snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList();
  }

  @override
  Future<void> upsert(TransactionDto transaction) async {
    final json = transaction.toJson();
    await _collection.doc(transaction.id).set(json);
  }

  @override
  Future<List<TransactionDto>> getUpdatedTransactions([DateTime? lastUpdatedAt]) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: currentUserId)
        .where('updatedAt', isGreaterThan: lastUpdatedAt)
        .orderBy('updatedAt')
        .get();

    return snapshot.docs.map((doc) => _fromFirestore(doc.data())).toList();
  }
}
