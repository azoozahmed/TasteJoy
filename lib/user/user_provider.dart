import 'package:flutter/material.dart';
import 'package:wesh_nakil5/user/auth_methods.dart';
import 'package:wesh_nakil5/user/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  final AuthMethods _authMethods = AuthMethods();

  UserData? get getUser => _userData;

  Future<void> refreshUser() async {
    UserData userData = await _authMethods.getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}
