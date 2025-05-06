import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPost {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImagesToStorage(
      String childName, List<Uint8List> files, String postID) async {
    List<String> urls = [];
    int count = 1;
    for (var file in files) {
      Reference ref =
          _storage.ref().child(childName).child(postID + count.toString());

      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      urls.add(downloadUrl);
      count++;
    }

    return urls;
  }

  Future<String> uploadPost({
    required String uid,
    required String postId,
    required String resName,
    required String des,
    required String latitude,
    required String longitude,
    required List<Uint8List> images,
    required List<String> likes,
  }) async {
    String resp = "success";
    try {
      List<String> urls =
          await uploadImagesToStorage("post_images", images, postId);
      await _firestore.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'resName': resName,
        'description': des,
        'latitude': latitude,
        'longitude': longitude,
         'imageUrls': urls,
         'liked_by': likes,
      });
      // await _firestore.collection('posts').doc(postId).collection('images').add({
      //   'imageUrls': urls,
      // });
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
