import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wesh_nakil5/pick_image.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm(
      {super.key, required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.profileImg});

  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImg;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProfileForm();
  }
}

class _EditProfileForm extends State<EditProfileForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String profileController;

  bool _isValidFirstName = false;
  final bool _isValidLastName = false;
  bool _isValidEmail = false;

  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailController.text = widget.email;
    profileController = widget.profileImg;
    super.initState();
  }

  Uint8List? _image;
  void imageUpload() async {
    final img = await pickImage(ImageSource.gallery);

    setState(() {
      if (img != null) {
        _image = img;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade800,
                Colors.orange.shade500,
              ],
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: MaterialButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            imageUpload();
                          },
                          child: Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(profileController),
                                    ),
                              const Positioned(
                                bottom: 3,
                                right: 5,
                                child: Icon(Icons.add_a_photo),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'الاسم الأول',
                                      hintText: 'ادخل اسمك الأول',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length > 12) {
                                        return '12 حرف على الأكثر';
                                      } else if (value.isEmpty) {
                                        return 'يرجى ادخال الاسم';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _isValidFirstName = value.length <= 12;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: TextFormField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'الاسم الأخير',
                                      hintText: 'ادخل اسمك الأخير',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length > 12) {
                                        return '12 حرف على الأكثر';
                                      } else if (value.isEmpty) {
                                        return 'يرجى ادخال الاسم';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _isValidFirstName = value.length <= 12;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'البريد الالكتروني',
                              hintText: 'قم بادخال البريد الالكتروني',
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (!value!.contains('@') ||
                                  value.isEmpty ||
                                  !value.contains('.')) {
                                return 'الرجاء إدخال بريد إلكتروني صحيح';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _isValidEmail = value.contains('@') &&
                                    value.isNotEmpty &&
                                    value.contains('.');
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 250,
                        margin: const EdgeInsets.only(top: 40, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              saveChanges();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'حفظ التعديلات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveChanges() async {
    //upload image
    String imageUrl = widget.profileImg;
    if (_image != null) {
      imageUrl = await uploadImageToStorage('profile_images', _image!);
    }
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(widget.uid).update({
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'profile_img': imageUrl
    });
    setState(() {
      showSpinner = false;
    });
    Navigator.pop(context);
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child(widget.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
