import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wesh_nakil5/add_post.dart';
import 'package:wesh_nakil5/home/home.dart';
import 'package:wesh_nakil5/home/offers.dart';
import 'package:wesh_nakil5/home/profile.dart';
import 'package:wesh_nakil5/user/login.dart';
import 'package:wesh_nakil5/user/signup.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAWFcrQf6l_6i0tMrfds_abKbKKTGJCDjo',
    appId: '1:978605004009:android:6b8af9de89d7a18fa94c78',
    messagingSenderId: '978605004009',
    projectId: 'foodapp-8750e',
    storageBucket: 'foodapp-8750e.appspot.com',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return MaterialApp(
                    title: "Wesh nakil",
                    theme: ThemeData(
                      primarySwatch: Colors.orange,
                    ),
                    home: Home(),
                    routes: {
                      "home": (context) => Home(),
                      "login": (context) => Login(),
                      "signup": (context) => Signup(),
                      "profile": (context) => Profile(),
                      "offers": (context) => Offers(),
                      "add_post": (context) => AddPost(),
                    });
              } else if (snapshot.hasError) {
                return MaterialApp(
                    title: "Wesh nakil",
                    theme: ThemeData(
                      primarySwatch: Colors.orange,
                    ),
                    home: Login(),
                    routes: {
                      "home": (context) => Home(),
                      "login": (context) => Login(),
                      "signup": (context) => Signup(),
                      "profile": (context) => Profile(),
                      "offers": (context) => Offers(),
                    });
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            }
            return MaterialApp(
                title: "TasteJoy",
                theme: ThemeData(
                  primarySwatch: Colors.orange,
                ),
                home: Login(),
                routes: {
                  "home": (context) => Home(),
                  "login": (context) => Login(),
                  "signup": (context) => Signup(),
                  "profile": (context) => Profile(),
                  "offers": (context) => Offers(),
                });
          }),
    );
  }
}
