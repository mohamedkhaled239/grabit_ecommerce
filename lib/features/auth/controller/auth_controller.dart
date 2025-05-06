import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/auth/controller/auth_state.dart';
import 'package:grabit_ecommerce/features/auth/model/auth_model.dart';

class AuthController extends Cubit<AuthState> {
  final AuthModel _authModel;

  AuthController(this._authModel) : super(AuthInitial()) {
    _checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authModel.loginWithEmailAndPassword(email, password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authModel.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _checkLoginStatus() async {
    try {
      final isLoggedIn = await _authModel.checkLoginStatus();
      final user = _authModel.currentUser;
      if (isLoggedIn && user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      await _authModel.deleteUser();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
