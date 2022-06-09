import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/social_data_agent.dart';

const newsFeedCollection = 'newsfeed';
const uploadPath = 'uploads';
const userPath = 'users';

class CloudFirestoreDatabaseDataAgentImpl extends SocialDataAgent {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var firebaseStorage = FirebaseStorage.instance;
  var auth = FirebaseAuth.instance;
  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsfeed() {
    //Snapshot => querySnapShot => docs => List<queryDocumentSnapshot> => data() => NewsFeedVO.fromJson => List<NewsfeedVO>
    return _firestore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<NewsFeedVO>((document) {
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<NewsFeedVO> getNewsfeedById(int newsfeedId) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(newsfeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) =>
            NewsFeedVO.fromJson(documentSnapShot.data()!));
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
    return _firestore
        .collection(userPath)
        .doc(newUser.id.toString())
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
    return _firestore
        .collection(userPath)
        .doc(auth.currentUser?.uid ?? '')
        .get()
        .then((documentSnapShot) {
      if (documentSnapShot.data() != null) {
        return UserVO.fromJson(documentSnapShot.data()!);
      } else {
        return Future.error('UserNotFound');
      }
    });
  }
}
