import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ← Add this
import 'package:grabit_ecommerce/features/checkout/view/checkout_payment_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/theme/controller/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'User';
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!;
    }
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    if (doc.exists && doc.data() != null && doc.data()!['name'] != null) {
      return doc.data()!['name'];
    }
    return 'User';
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 1,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: user == null
          ? Center(child: Text('No user found', style: theme.textTheme.bodyLarge))
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: theme.colorScheme.surface,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: theme.colorScheme.onSurface,
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),
                    FutureBuilder<String>(
                      future: getUserName(),
                      builder: (context, snapshot) {
                        final name = snapshot.data ?? 'User';
                        return Text(
                          name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.email ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, state) {
                        final themeCubit = context.read<ThemeCubit>();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dark Mode',
                                style: theme.textTheme.titleMedium,
                              ),
                              Switch(
                                value: themeCubit.isDarkMode,
                                onChanged: (value) {
                                  themeCubit.toggleTheme();
                                },
                                activeColor: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        onPressed: () => _logout(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
