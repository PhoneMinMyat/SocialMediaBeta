// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFeedVO _$NewsFeedVOFromJson(Map<String, dynamic> json) => NewsFeedVO(
      id: json['id'] as int?,
      description: json['description'] as String?,
      profilePicture: json['profile_picture'] as String?,
      userName: json['user_name'] as String?,
      postImage: json['post_image'] as String?,
    );

Map<String, dynamic> _$NewsFeedVOToJson(NewsFeedVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'profile_picture': instance.profilePicture,
      'user_name': instance.userName,
      'post_image': instance.postImage,
    };
