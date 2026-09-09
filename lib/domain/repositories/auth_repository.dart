import 'package:restaurant_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future <User> register (String email, String password, String name);
}