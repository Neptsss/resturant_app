import 'package:restaurant_app/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String keyUser = '@key user';

  AuthLocalDataSourceImpl({required SharedPreferences sp})
    : _sharedPreferences = sp;

  @override
  Future<void> saveUser(User u) async {
    final userJson = json.encode(u.toJson());
    await _sharedPreferences.setString(keyUser, userJson);
  }

  @override
  Future<User?> getUser() async {
    final userJson = _sharedPreferences.getString(keyUser);
    if (userJson == null) {
      return null;
    }

    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      await deleteUser();
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _sharedPreferences.remove(keyUser);
  }
}
