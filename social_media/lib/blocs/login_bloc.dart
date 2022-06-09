import 'package:flutter/cupertino.dart';
import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  bool isDisposed = false;

  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  Future onTapLogin() {
    _showLoading();
    return authenticationModel
        .logInUser(email, password)
        .whenComplete(() => _hideLoading());
  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
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
