import 'dart:io';

import 'package:social_media/data/vos/news_feed_vo.dart';

abstract class SocialModel{
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewsPost( String newPostDescription, File? image);
  Future<void> editNewsFeedPost(NewsFeedVO editedPost, File? image);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
}