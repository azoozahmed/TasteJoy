import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:wesh_nakil5/user/user_data.dart';

class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;
  late UserCredential cred;

  //Upload profile picture to firebase
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child(cred.user!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //Upload user data to firebase
  Future<String> registerUser({
    required String email,
    required String password,
    required String first_name,
    required String last_name,
    required Uint8List? profileImage,
  }) async {
    String resp = "success";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          first_name.isNotEmpty &&
          last_name.isNotEmpty) {
        cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String imageUrl =
            await uploadImageToStorage('profile_images', profileImage!);
        UserData userData = UserData(
          uid: cred.user!.uid,
          first_name: first_name,
          last_name: last_name,
          email: email,
          profile_img: imageUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              userData.toJson(),
            );
      }
    } catch (err) {
      if (err is FirebaseAuthException) {
        if (err.code == 'email-already-in-use') {
          resp = "email exists";
        } else {
          resp = err.message ?? "An error occurred";
        }
      }
    }
    return resp;
  }

  //login user
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String resp = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        resp = "success";
      } else {
        resp = "empty";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        resp = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        resp = "Wrong password provided.";
      }
    }
    return resp;
  }

  //get user data
  Future<UserData> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnap(snap);
  }

  //update user data
}
