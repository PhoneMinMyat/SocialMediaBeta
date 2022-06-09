import 'dart:io';

import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/network/cloud_firestore_database_data_agent.dart';
import 'package:social_media/network/real_time_database_data_agent_impl.dart';
import 'package:social_media/network/social_data_agent.dart';
import 'package:social_media/resources/images.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();
  //SocialDataAgent dataAgent = CloudFirestoreDatabaseDataAgentImpl();

  AuthenticationModel authenticationModel = AuthenticationModelImpl();
  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return dataAgent.getNewsfeed();
  }

  @override
  Future<void> addNewsPost(String newPostDescription, File? image) {
    if (image != null) {
      return dataAgent.uploadFileToFirebase(image).then((imageUrl) =>
          craftNewFeedVO(newPostDescription, imageUrl)
              .then((newsFeedPost) => dataAgent.addNewPost(newsFeedPost)));
    } else {
      return craftNewFeedVO(newPostDescription, "")
          .then((newsFeedPost) => dataAgent.addNewPost(newsFeedPost));
    }
  }

  @override
  Future<void> editNewsFeedPost(NewsFeedVO editedPost, File? image) {
    if (image != null) {
      return dataAgent.uploadFileToFirebase(image).then((imageUrl) {
        NewsFeedVO tempPost = editedPost;
        tempPost.postImage = imageUrl;
        dataAgent.addNewPost(tempPost);
      });
    } else {
      return dataAgent.addNewPost(editedPost);
    }
  }

  Future<NewsFeedVO> craftNewFeedVO(String description, String imageUrl) {
    var currentMilliSeconds = DateTime.now().millisecondsSinceEpoch;
    return authenticationModel.getLoggedInUser().then((user) {
      var newPost = NewsFeedVO(
          id: currentMilliSeconds,
          userName: user.userName,
          postImage: imageUrl,
          description: description,
          profilePicture: (user.profilePictureUrl?.isNotEmpty ?? false)
              ? user.profilePictureUrl
              : NETWORK_IMAGE_POST_PLACEHOLDER);

      return Future.value(newPost);
    });
  }

  @override
  Future<void> deletePost(int postId) {
    return dataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return dataAgent.getNewsfeedById(newsFeedId);
  }
}
