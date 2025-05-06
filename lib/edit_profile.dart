import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wesh_nakil5/edit_profile_form.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userId});

  final String userId;
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Add navigation logic here
            },
          ),
          title: const Text(''),
          centerTitle: true,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(
              color: Colors.orange,
            );
          } else {
            var output = snapshot.data!.data();
            var firstName = output!['first_name'];
            var lastName = output['last_name'];
            var email = output['email'];
            var profileImg = output['profile_img'];

            return Padding(
              padding: const EdgeInsets.all(10),
              child: EditProfileForm(
                  uid: widget.userId,
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  profileImg: profileImg),
            );
          }
        },
      ),
    );
  }
}
