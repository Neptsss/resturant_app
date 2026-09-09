import 'package:flutter/material.dart';
import 'package:restaurant_app/core/errors/exception.dart';
import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/usecase/auth_usecase.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

enum FormStatus { initial, submitting, succes, error }

class AuthProvider extends ChangeNotifier {
  // Dependency
  final AuthUseCase _authUseCase;

  // state
  AuthStatus _authStatus = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  // Form Status
  FormStatus _registerStatus = FormStatus.initial;

  AuthProvider({required AuthUseCase authUsecase}) : _authUseCase = authUsecase;

  // getters
  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  FormStatus get registerStatus => _registerStatus;

  Future<void> register(String email, String password, String name) async {
    _registerStatus = FormStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authUseCase.register(email, password, name);
      _user = user;
      _authStatus = AuthStatus.authenticated;
      _registerStatus = FormStatus.succes;
    } catch (e) {
      _registerStatus = FormStatus.error;
      if (e is ServerException) {
        _errorMessage = e.message.toString();
      } else {
        _errorMessage = e.toString();
      }
    }
    notifyListeners();
  }

  void resetRegsterStatus() {
    _registerStatus = FormStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
