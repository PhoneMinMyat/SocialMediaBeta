import 'dart:io';

import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/cloud_firestore_database_data_agent.dart';
import 'package:social_media/network/real_time_database_data_agent_impl.dart';
import 'package:social_media/network/social_data_agent.dart';
import 'package:social_media/resources/images.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();
  //SocialDataAgent dataAgent = CloudFirestoreDatabaseDataAgentImpl();

  @override
  Future<void> registerUser(
      String email, String userName, String password, File? profileImage) {
    if (profileImage != null) {
      return dataAgent.uploadFileToFirebase(profileImage).then((profileUrl) =>
          craftUserVO(email, userName, password, profileUrl)
              .then((newUser) => dataAgent.registerNewUser(newUser)));
    } else {
      return craftUserVO(email, userName, password, NETWORK_IMAGE_POST_PLACEHOLDER)
          .then((newUser) => dataAgent.registerNewUser(newUser));
    }
  }

  Future<UserVO> craftUserVO(
      String email, String userName, String password, String profileUrl) {
    UserVO newUser = UserVO(
      id: '',
      email: email,
      userName: userName,
      password: password,
      profilePictureUrl: profileUrl,
    );

    return Future.value(newUser);
  }

  @override
  Future<UserVO> getLoggedInUser() {
    return dataAgent.getUserById();
  }

  @override
  bool isLoggedIn() {
    return dataAgent.isLoggedIn();
  }

  @override
  Future<void> logInUser(String email, String password) {
    return dataAgent.logInUser(email, password);
  }

  @override
  Future<void> logOut() {
    return dataAgent.logOut();
  }
}
