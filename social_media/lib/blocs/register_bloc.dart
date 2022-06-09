import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';

class RegisterBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  String userName = "";
  bool isDisposed = false;
  File? choseImageFile;
  String? imageUrl;

  AuthenticationModel model = AuthenticationModelImpl();

  Future onTapRegister() {
    _showLoading();
    return model
        .registerUser(email, userName, password,choseImageFile)
        .whenComplete(() => _hideLoading());
  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
  }

  void onUserNameChanged(String username) {
    userName = username;
  }

  void onImageChosen(File choseImage) {
    choseImageFile = choseImage;
    safeNotifyListeners();
  }

  void onTapDeleteImage() {
    choseImageFile = null;
    if (imageUrl?.isNotEmpty ?? false) {
      imageUrl = null;
    }
    safeNotifyListeners();
  }

  void _showLoading() {
    isLoading = true;
    safeNotifyListeners();
  }

  void _hideLoading() {
    isLoading = false;
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
