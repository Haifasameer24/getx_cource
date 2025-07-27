import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileImageController extends GetxController {
  var photoUrl = ''.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();

  String get currentUserId => _auth.currentUser?.uid ?? '';

  Future<void> loadProfileImage() async {
    if (currentUserId.isEmpty) return;
    final doc = await _firestore.collection('users').doc(currentUserId).get();
    photoUrl.value = doc.data()?['photoUrl'] ?? '';
  }

  Future<void> pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final ref = FirebaseStorage.instance.ref().child('profile_images').child('$currentUserId.jpg');

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    photoUrl.value = url;

    await _firestore.collection('users').doc(currentUserId).update({
      'photoUrl': url,
    });
  }
}
