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
  bool _isSuccessSendForgotPassword = false;

  // Form Status
  FormStatus _registerStatus = FormStatus.initial;
  FormStatus _loginStatus = FormStatus.initial;
  FormStatus _forgotPasswordStatus = FormStatus.initial;

  AuthProvider({required AuthUseCase authUsecase})
    : _authUseCase = authUsecase {
    checkAuthStatus(); // mengecek auth status saat provider di muat
  }

  // getters
  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  FormStatus get registerStatus => _registerStatus;
  FormStatus get loginStatus => _loginStatus;
  FormStatus get forgotPasswordStatus => _forgotPasswordStatus;
  bool get isSuccessSendForgotPasword=>_isSuccessSendForgotPassword;

  Future<void> checkAuthStatus() async {
    if (_authStatus != AuthStatus.initial) {
      return;
    }

    try {
      final user = await _authUseCase.getCurrentUser();
      if (user != null) {
        _user = user;
        _authStatus = AuthStatus.authenticated;
      } else {
        _authStatus = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      print('Error checking Auth status : $e');
    }
    notifyListeners();
  }

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

  Future<void> login(String email, String password) async {
    _loginStatus = FormStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authUseCase.login(email, password);
      _user = user;
      _authStatus = AuthStatus.authenticated;
      _loginStatus = FormStatus.succes;
    } catch (e) {
      _loginStatus = FormStatus.error;
      if (e is ServerException) {
        _errorMessage = e.message.toString();
      } else {
        _errorMessage = e.toString();
      }
    }
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    _forgotPasswordStatus = FormStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authUseCase.resetPassword(email);
      _forgotPasswordStatus = FormStatus.succes;
      _isSuccessSendForgotPassword = true;
    } catch (e) {
      _forgotPasswordStatus = FormStatus.error;
      _isSuccessSendForgotPassword = false;

      if (e is ServerException) {
        _errorMessage = e.message.toString();
      } else {
        _errorMessage = e.toString();
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authUseCase.logout();
      _user = null;
      _authStatus = AuthStatus.unauthenticated;
    } catch (e) {
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

  void resetLoginStatus() {
    _loginStatus = FormStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  void resetForgotPassword() {
    _forgotPasswordStatus = FormStatus.initial;
    _errorMessage = null;
      _isSuccessSendForgotPassword = false;
    notifyListeners();
  }
}
