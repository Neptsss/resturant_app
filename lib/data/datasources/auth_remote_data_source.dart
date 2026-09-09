import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/core/errors/exception.dart';
import 'package:restaurant_app/domain/entities/user.dart' as user_app;

abstract class AuthRemoteDataSource {
  Future<user_app.User> register(String email, String password, String name);
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
        name: name,
        email: userCredential.user!.email ?? '',
        createdAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        updatedAt:
            userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
        photoUrl: userCredential.user!.photoURL,
      );
    } catch (e) {
      print('Error register, $e');
      throw ServerException(message: "Login gagal : ${e.toString()}");
    }
  }
}
