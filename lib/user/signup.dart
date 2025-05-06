// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wesh_nakil5/user/auth_methods.dart';
import 'package:wesh_nakil5/user/login.dart';
import 'package:wesh_nakil5/pick_image.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Signup();
  }
}

class _Signup extends State<Signup> {
  bool showSpinner = false;

  Uint8List? _image;

  String email_error = "";
  void imageUpload() async {
    final img = await pickImage(ImageSource.gallery);

    setState(() {
      if (img != null) {
        _image = img;
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isValidFirstName = false;
  final bool _isValidLastName = false;
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade800,
                  Colors.orange.shade500,
                ],
              ),
            ),
            child: Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  height: 665,
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
                                      : const CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              AssetImage("images/avatar.png"),
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
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          labelText: 'الاسم الأول',
                                          hintText: 'ادخل اسمك الأول',
                                          hintStyle:
                                              const TextStyle(color: Colors.grey),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                            _isValidFirstName =
                                                value.length <= 12;
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
                                        controller: _lastNameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          labelText: 'الاسم الأخير',
                                          hintText: 'ادخل اسمك الأخير',
                                          hintStyle:
                                              const TextStyle(color: Colors.grey),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                            _isValidFirstName =
                                                value.length <= 12;
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
                                controller: _emailController,
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
                                  } else if (email_error == "email exists") {
                                    return 'هذا البريد مسجل بالفعل!';
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'كلمة المرور',
                                  hintText: 'قم بادخال كلمة المرور',
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
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'يرجى إدخال كلمة مرور صحيحة';
                                  } else if (value.length < 8) {
                                    return 'يرجى ادخال أكثر من 8 أحرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _isValidPassword = value.isNotEmpty;
                                    _isValidPassword = value.length > 8;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 13, left: 10, right: 10),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'أعد كتابة كلمة المرور',
                                  hintText: 'كلمة المرور',
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
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'يجب أن تتطابق كلمة المرور';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _isValidConfirmPassword =
                                        value == _passwordController.text;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 250,
                            margin: const EdgeInsets.only(top: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  register();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                'تسجيل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  const Expanded(
                                    child: Divider(
                                      color: Colors
                                          .grey, // Change the color as needed
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                          );
                                        },
                                        child: const Text(
                                          'عندك حساب؟ سجل الدخول',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 71, 129),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  const Expanded(
                                    child: Divider(
                                      color: Colors
                                          .grey, // Change the color as needed
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }

  void register() async {
    setState(() {
      showSpinner = true;
    });
    if (_image == null) {
      Uint8List imageUint8List = await getImageUint8List('images/avatar.png');
      _image = imageUint8List;
    }
    String resp = await AuthMethods().registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        first_name: _firstNameController.text,
        last_name: _lastNameController.text,
        profileImage: _image);

    if (resp == 'success') {
      setState(() {
        showSpinner = false;
      });
      Navigator.popAndPushNamed(context, "home");
    } else if (resp == "email exists") {
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: const Text(
                  "هذا البريد مسجل بالفعل!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      TextButton(
                        child: const Text("حسنا"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("تسجيل الدخول"),
                        onPressed: () {
                          Navigator.popAndPushNamed(context, "login");
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      });
    } else {
      print(resp);
    }
  }
}
