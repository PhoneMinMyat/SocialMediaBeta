// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      email: json['email'] as String?,
      userName: json['user_name'] as String?,
      password: json['password'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_name': instance.userName,
      'password': instance.password,
      'profile_picture_url': instance.profilePictureUrl,
    };
