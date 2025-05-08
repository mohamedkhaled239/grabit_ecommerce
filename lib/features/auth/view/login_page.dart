import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/core/widgets/custom_button.dart';
import 'package:grabit_ecommerce/core/widgets/custom_text_field.dart';
import 'package:grabit_ecommerce/features/auth/controller/auth_controller.dart';
import 'package:grabit_ecommerce/features/auth/controller/auth_state.dart';
import 'package:grabit_ecommerce/features/root_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(height: 150),
            Image.asset('assets/images/logoapp.png', height: 200),
            CustomTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              obscureText: false,
              prefixIcon: Icons.email_outlined,
              focusedBorderColor: Colors.deepPurple,
            ),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Enter your password',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: BlocConsumer<AuthController, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: ${state.error}')),
                    );
                  }
                  if (state is AuthSuccess) {
                    Navigator.pushNamed(context, '/root');
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthController>().login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'don\'t have an account?',
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    '  Sign Up',
                    style: TextStyle(color: Color(0xff1B0260).withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
