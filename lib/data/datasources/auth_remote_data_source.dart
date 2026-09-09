import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/core/errors/exception.dart';
import 'package:restaurant_app/domain/entities/user.dart' as user_app;

abstract class AuthRemoteDataSource {
  Future<user_app.User> register(String email, String password, String name);
  Future<user_app.User> login(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<user_app.User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  Future<user_app.User> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: "Login gagal : User tidak di temukan");
      }

      await userCredential.user!.updateDisplayName(name);

      await userCredential.user!.reload();

      return user_app.User(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        createdAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        updatedAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        photoUrl: userCredential.user!.photoURL,
      );
    } catch (e) {
      print('Error register, $e');
      throw ServerException(message: "Register gagal : ${e.toString()}");
    }
  }

  Future<user_app.User> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: "Login gagal : User tidak di temukan");
      }

      return user_app.User(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        createdAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        updatedAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        photoUrl: userCredential.user!.photoURL,
      );
    } catch (e) {
      print('Error Login, $e');
      throw ServerException(message: "Login gagal : ${e.toString()}");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error Forget Password, $e');
      throw ServerException(message: "Forget Password gagal : ${e.toString()}");
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error Logout, $e');
      throw ServerException(message: "Logout gagal : ${e.toString()}");
    }
  }

  Future<user_app.User?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }
      return user_app.User(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        createdAt: user.metadata.lastSignInTime ?? DateTime.now(),
        updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
        photoUrl: user.photoURL,
      );
    } catch (e) {
      print('Error getCurrentUser, $e');
      throw ServerException(message: "getCurrentUser gagal : ${e.toString()}");
    }
  }
}
