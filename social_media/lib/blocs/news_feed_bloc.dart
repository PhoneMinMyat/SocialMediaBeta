import 'package:flutter/foundation.dart';
import 'package:social_media/analytics/firebase_analytics_tracker.dart';
import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  List<NewsFeedVO>? newsFeedList;

  final SocialModel model = SocialModelImpl();
  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  bool isDisposed = false;

  NewsFeedBloc() {
    model.getNewsFeed().listen((newsfeedList) {
      newsFeedList = newsfeedList;
      safeNotifyListener();
    });

    _sendAnalyticsData();
  }

  Future<void> onTapLogOut() {
    return authenticationModel.logOut();
  }

  Future onTapPostDelete(int postId) {
    return model.deletePost(postId);
  }

  void safeNotifyListener() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _sendAnalyticsData() async{
    return FirebaseAnalyticsTracker().logEvent(homeScreenReached, null);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
