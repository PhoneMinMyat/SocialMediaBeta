import 'dart:io';

import 'package:social_media/data/vos/user_vo.dart';

abstract class AuthenticationModel{
  Future<void> registerUser(String email, String userName, String password, File? profileImage);

  Future<void> logInUser(String email, String password);

  bool isLoggedIn();

  Future<UserVO> getLoggedInUser();

  Future<void> logOut();
}