import 'dart:io';

import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';

abstract class SocialDataAgent{
  Stream<List<NewsFeedVO>> getNewsfeed();
  Future<void> addNewPost(NewsFeedVO newPost);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsfeedById(int newsfeedId);
  Future<String> uploadFileToFirebase(File image);


  //Authentication
  Future registerNewUser(UserVO newUser);
  Future logInUser(String email, String password);
  bool isLoggedIn();
  Future logOut();
  Future<UserVO> getUserById();
}