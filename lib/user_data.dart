import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String first_name;
  final String last_name;
  final String uid;
  final String email;
  final String profile_img;

  const UserData(
      {required this.uid,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.profile_img});

  Map<String, dynamic> toJson() => {
        "first_name": first_name,
        "last_name": last_name,
        "uid": uid,
        "email": email,
        "profile_img": profile_img,
      };

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
        uid: snapshot['uid'],
        first_name: snapshot['first_name'],
        last_name: snapshot['last_name'],
        email: snapshot['email'],
        profile_img: snapshot['profile_img']);
  }
}
