import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/dto/transaction_dto.dart';

abstract class TransactionRemoteDatasource {
  Future<void> create(TransactionDto transaction);
  Future<void> update(TransactionDto transaction);
  Future<void> delete(String id);
  Future<TransactionDto?> getById(String id);
  Stream<List<TransactionDto>> watchUserTransactions(String userId);
  Future<List<TransactionDto>> getUserTransactions(String userId);
}

@LazySingleton(as: TransactionRemoteDatasource)
class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  const TransactionRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('transactions');

  @override
  Future<void> create(TransactionDto transaction) async {
    await _collection.doc(transaction.id).set(transaction.toJson());
  }

  @override
  Future<void> update(TransactionDto transaction) async {
    await _collection.doc(transaction.id).update(transaction.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<TransactionDto?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return TransactionDto.fromJson(doc.data()!);
  }

  @override
  Stream<List<TransactionDto>> watchUserTransactions(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TransactionDto.fromJson(doc.data())).toList());
  }

  @override
  Future<List<TransactionDto>> getUserTransactions(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).orderBy('date', descending: true).get();

    return snapshot.docs.map((doc) => TransactionDto.fromJson(doc.data())).toList();
  }
}
