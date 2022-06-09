import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_media/analytics/firebase_analytics_tracker.dart';
import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/remote_config/flutter_remote_config.dart';
import 'package:social_media/resources/images.dart';

class AddNewPostBloc extends ChangeNotifier {
  ///State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isLoading = false;
  bool isDisposed = false;
  String profilePicture = "";
  String userName = "";
  Color themeColor = Colors.black;

  File? choseImageFile;
  String? imageUrl;

  NewsFeedVO? mNewsFeed;

  final SocialModel _model = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();
  final FlutterRemoteConfig _remoteConfig = FlutterRemoteConfig();

  AddNewPostBloc({int? newsFeedId}) {
    profilePicture = NETWORK_IMAGE_POST_PLACEHOLDER;
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }


    _sendAnalyticsData(addNewPostScreenReached, null);
    getThemeColorFromRemoteConfigAndChange();
  }


  bool isInEditMode = false;

  void onTextChanged(String newText) {
    newPostDescription = newText;
  }

  void getThemeColorFromRemoteConfigAndChange(){
    themeColor = _remoteConfig.getThemeColorFromRemoteConfig();
    safeNotifyListener();
  }

  Future<void> onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      safeNotifyListener();
      return Future.error('error');
    } else {
      isLoading = true;
      safeNotifyListener();
      isAddNewPostError = false;
      if (isInEditMode) {
        return editNewsFeedPost().then((value) {
          isLoading = false;
          safeNotifyListener();
          _sendAnalyticsData(editPostAction, {postId: mNewsFeed?.id.toString()});
        });
      } else {
        return addNewPost().then((value) {
          isLoading = false;
          safeNotifyListener();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
    }
  }

  Future<void> editNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;
    if (imageUrl == null) {
      mNewsFeed?.postImage = "";
    }
    if (mNewsFeed != null) {
      return _model.editNewsFeedPost(mNewsFeed!, choseImageFile);
    } else {
      return Future.error('Error');
    }
  }

  Future<void> addNewPost() {
    return _model.addNewsPost(newPostDescription, choseImageFile);
  }

  void onImageChosen(File choseImage) {
    choseImageFile = choseImage;
    safeNotifyListener();
  }

  void onTapDeleteImage() {
    choseImageFile = null;
    if (imageUrl?.isNotEmpty ?? false) {
      imageUrl = null;
    }
    safeNotifyListener();
  }

  void _prepopulateDataForAddNewPost() {
    _authenticationModel.getLoggedInUser().then((user) {
      userName = user.userName ?? '';
      profilePicture = user.profilePictureUrl ?? '';
      safeNotifyListener();
    });
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeed) {
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      newPostDescription = newsFeed.description ?? "";
      imageUrl = newsFeed.postImage;
      mNewsFeed = newsFeed;
      safeNotifyListener();
    });
  }

  void safeNotifyListener() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _sendAnalyticsData(String name, Map<String, dynamic>? parameters)async{
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
