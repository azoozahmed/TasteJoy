// ignore_for_file: unused_field

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart";
import "package:wesh_nakil5/user/auth_methods.dart";
import "package:wesh_nakil5/user/signup.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isValidEmail = false;
  bool _isValidPassword = false;

  bool showSpinner = false;
  String wrongInput = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (user != null) {
      Navigator.popAndPushNamed(context, 'home');
    }
  }

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade800,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Image.asset(
                        "images/foodpic.png",
                        fit: BoxFit.cover,
                        height: 250,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'البريد الالكتروني',
                                      hintText: 'ادخل البريد الالكتروني',
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
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFormField(
                                    obscureText: true,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'كلمة المرور',
                                      hintText: 'ادخل كلمة المرور',
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
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            wrongInput,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                signin();
                              }
                            },
                            height: 50,
                            color: Colors.orange[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "نسيت كلمة المرور؟",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 40),
                          Center(
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
                                              builder: (context) => Signup()),
                                        );
                                      },
                                      child: const Text(
                                        'تسجيل حساب جديد',
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
                          const SizedBox(height: 100),
                          // Text(
                          //   "Continue with social media",
                          //   style: TextStyle(color: Colors.grey),
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: MaterialButton(
                          //         onPressed: (){},
                          //         height: 50,
                          //         color: Colors.blue,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(50),
                          //         ),
                          //         child: Center(
                          //           child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 30,),
                          //     Expanded(
                          //       child: MaterialButton(
                          //         onPressed: () {},
                          //         height: 50,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(50),

                          //         ),
                          //         color: Colors.black,
                          //         child: Center(
                          //           child: Text("Github", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signin() async {
    setState(() {
      showSpinner = true;
    });
    String resp = await AuthMethods().login(
        email: _emailController.text, password: _passwordController.text);

    if (resp == "No user found for that email") {
    } else if (resp == "Wrong password provided.") {
    } else if (resp == "success") {
      Navigator.popAndPushNamed(context, 'home');
    } else {}
    setState(() {
      showSpinner = false;
      wrongInput = "البريد أو كلمة المرور غير صحيح";
    });
  }
}
