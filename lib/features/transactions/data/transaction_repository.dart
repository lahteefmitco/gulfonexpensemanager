import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:gulfon_expense_manager/config/environment.dart';
import 'package:gulfon_expense_manager/features/transactions/data/models/transaction_model.dart';

class TransactionRepository {
  final Databases _databases;

  TransactionRepository(Client client) : _databases = Databases(client);

  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.transactionsCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('date'),
        ],
      );
      return documentList.documents
          .map((doc) => TransactionModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      log("getTransactions: ${e.toString()}");
      rethrow;
    }
  }

  Future<TransactionModel> createTransaction(
      TransactionModel transaction, String userId) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.transactionsCollectionId,
        documentId: ID.unique(),
        data: {
          ...transaction.toMap(),
          'userId': userId,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      return TransactionModel.fromMap(doc.data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _databases.deleteDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.transactionsCollectionId,
        documentId: transactionId,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<TransactionModel> updateTransaction(
      TransactionModel transaction, String userId) async {
    try {
      final doc = await _databases.updateDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.transactionsCollectionId,
        documentId: transaction.id,
        data: {
          ...transaction.toMap(),
          'userId': userId,
        },
      );
      return TransactionModel.fromMap(doc.data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
