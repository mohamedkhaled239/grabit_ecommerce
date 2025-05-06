import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImagePath,
    String role = 'user', // Default role
  }) async {
    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) return null;

      final userId = userCredential.user!.uid;

      // 2. Upload profile image if provided
      String? imageUrl;
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        imageUrl = await _uploadProfileImage(userId, profileImagePath);
      }

      // 3. Create user document in Firestore
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'name': name,
        'email': email,
        'profileImage': imageUrl ?? '',
        'phone': phone ?? '',
        'role': role,
        'wishlist': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      // Clean up if any step fails
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        throw 'Email already in use';
      }
      rethrow;
    }
  }

  Future<String> _uploadProfileImage(String userId, String imagePath) async {
    try {
      final ref = _storage.ref(
        'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}',
      );
      final uploadTask = ref.putFile(File(imagePath));
      final snapshot = await uploadTask.whenComplete(() => null);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Failed to upload profile image';
    }
  }

  Future<File?> pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw 'Failed to pick image';
    }
  }
}
