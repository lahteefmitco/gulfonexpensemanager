import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:gulfon_expense_manager/config/environment.dart';

class AuthRepository {
  final Client _client;
  late final Account _account;

  AuthRepository()
      : _client = Client()
            .setEndpoint(Environment.appwritePublicEndpoint)
            .setProject(Environment.appwriteProjectId) {
    _account = Account(_client);
  }

  Future<models.User> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<models.Session> login(
      {required String email, required String password}) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }
}
