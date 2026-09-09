import 'package:restaurant_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future <User> register (String email, String password, String name);
  Future <User> login (String email, String password);
  Future <void> resetPassword (String email);
  Future <void> signOut ();
  Future <User?> getCurrentUser ();
}