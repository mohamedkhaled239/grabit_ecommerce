import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/auth/model/register_model.dart';
import 'package:grabit_ecommerce/features/auth/controller/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends Cubit<RegisterState> {
  final RegisterModel _registerModel;

  RegisterController(this._registerModel) : super(RegisterInitial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String profileImage = '',
  }) async {
    emit(RegisterLoading());
    try {
      final user = await _registerModel.registerUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        profileImagePath: profileImage,
      );

      if (user != null) {
        // Update displayName in FirebaseAuth
        await user.updateDisplayName(name);
        await user.reload();
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure('Registration failed'));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
