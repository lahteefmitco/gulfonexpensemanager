import 'package:appwrite/appwrite.dart';
import 'package:gulfon_expense_manager/config/environment.dart';
import 'package:gulfon_expense_manager/features/categories/data/models/category_model.dart';

class CategoryRepository {
  final Databases _databases;

  CategoryRepository(Client client) : _databases = Databases(client);

  Future<List<CategoryModel>> getCategories(String userId) async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.categoriesCollectionId,
        queries: [
          Query.equal('userId', userId),
        ],
      );
      return documentList.documents
          .map((doc) => CategoryModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryModel> createCategory(
      CategoryModel category, String userId) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.categoriesCollectionId,
        documentId: ID.unique(),
        data: {
          ...category.toMap(),
          'userId': userId,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      return CategoryModel.fromMap(doc.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _databases.deleteDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.categoriesCollectionId,
        documentId: categoryId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
