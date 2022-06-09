import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/social_data_agent.dart';

const newsfeedPath = 'newsfeed';
const uploadPath = 'uploads';
const userPath = 'users';

class RealTimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealTimeDatabaseDataAgentImpl _singleton =
      RealTimeDatabaseDataAgentImpl._internal();

  factory RealTimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealTimeDatabaseDataAgentImpl._internal();

  //Database
  var databaseRef = FirebaseDatabase.instance.ref();
  var firebaseStorage = FirebaseStorage.instance;
  var auth = FirebaseAuth.instance;

  @override
  Stream<List<NewsFeedVO>> getNewsfeed() {
    return databaseRef.child(newsfeedPath).onValue.map((event) {
      return event.snapshot.children.map<NewsFeedVO>((snapshot) {
        return NewsFeedVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return databaseRef
        .child(newsfeedPath)
        .child(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsfeedPath).child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsfeedById(int newsfeedId) {
    return databaseRef
        .child(newsfeedPath)
        .child(newsfeedId.toString())
        .once()
        .asStream()
        .map((event) {
      return NewsFeedVO.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map));
    });
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    String milisecondsId = DateTime.now().millisecondsSinceEpoch.toString();
    return firebaseStorage
        .ref(uploadPath)
        .child(milisecondsId)
        .putFile(image)
        .then((taskSnapShot) => taskSnapShot.ref.getDownloadURL());
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? '', password: newUser.password ?? '')
        .then((userCredential) =>
            userCredential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid;
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return databaseRef
        .child(userPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  // @override
  // UserVO getLoggedInUser() {
  //   UserVO currentUser = UserVO(
  //       id: auth.currentUser?.uid,
  //       email: auth.currentUser?.email,
  //       userName: auth.currentUser?.displayName);
  //   getUserById(auth.currentUser?.uid ?? '').then((user) {
  //     currentUser.profilePictureUrl = user.profilePictureUrl;
  //   });

  //   return currentUser;
  // }

  @override
  bool isLoggedIn() {
    return (auth.currentUser != null);
  }

  @override
  Future logInUser(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future logOut() {
    return auth.signOut();
  }

  @override
  Future<UserVO> getUserById() {
    return databaseRef
        .child(userPath)
        .child(auth.currentUser?.uid ?? '')
        .once()
        .then((event) {
      return UserVO.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map));
    });
  }
}
