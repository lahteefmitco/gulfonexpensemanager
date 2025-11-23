import 'package:appwrite/appwrite.dart';
import 'package:gulfon_expense_manager/config/environment.dart';
import 'package:gulfon_expense_manager/features/accounts/data/models/account_model.dart';

class AccountRepository {
  final Databases _databases;

  AccountRepository(Client client) : _databases = Databases(client);

  Future<List<AccountModel>> getAccounts(String userId) async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.accountsCollectionId,
        queries: [
          Query.equal('userId', userId),
        ],
      );
      return documentList.documents
          .map((doc) => AccountModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AccountModel> createAccount(
      AccountModel account, String userId) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.accountsCollectionId,
        documentId: ID.unique(),
        data: {
          ...account.toMap(),
          'userId': userId,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      return AccountModel.fromMap(doc.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AccountModel> updateAccount(AccountModel account) async {
    try {
      final doc = await _databases.updateDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.accountsCollectionId,
        documentId: account.id,
        data: account.toMap(),
      );
      return AccountModel.fromMap(doc.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String accountId) async {
    try {
      await _databases.deleteDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.accountsCollectionId,
        documentId: accountId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
