import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/core/widgets/custom_button.dart';
import 'package:grabit_ecommerce/core/widgets/custom_text_field.dart';
import 'package:grabit_ecommerce/features/auth/controller/register_controller.dart';
import 'package:grabit_ecommerce/features/auth/controller/register_state.dart';
import 'package:grabit_ecommerce/features/auth/model/register_model.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_cubit.dart';
import 'package:grabit_ecommerce/features/root_screen.dart';
import 'package:grabit_ecommerce/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterController(RegisterModel()),
      child: Scaffold(
        body: BlocListener<RegisterController, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create:
                            (_) => CartCubit(
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                        child: RootScreen(),
                      ),
                ),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: BlocBuilder<RegisterController, RegisterState>(
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state is RegisterLoading,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 70),

                        GestureDetector(
                          onTap: () => _pickProfileImage(context),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                            child:
                                _profileImage == null
                                    ? Icon(Icons.camera_alt, size: 16)
                                    : null,
                          ),
                        ),
                        SizedBox(height: 10),

                        CustomTextField(
                          controller: _nameController,
                          hintText: S.of(context).Enter_your_full_name,
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                        SizedBox(height: 5),

                        CustomTextField(
                          controller: _emailController,
                          hintText: S.of(context).email,
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                        SizedBox(height: 5),

                        CustomTextField(
                          controller: _phoneController,
                          hintText: S.of(context).Enter_your_password,
                          prefixIcon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                        SizedBox(height: 5),

                        CustomTextField(
                          controller: _passwordController,
                          hintText: S.of(context).password,
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 5),

                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText:
                              S.of(context).Enter_your_password_confirmation,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        CustomButton(
                          text: S.of(context).Register,
                          onPressed: () => _registerUser(context),
                        ),

                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            S.of(context).Already_have_account,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  File? _profileImage;

  Future<void> _pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _registerUser(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterController>().registerUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        profileImage: _profileImage != null ? _profileImage!.path : '',
      );
    }
  }
}
