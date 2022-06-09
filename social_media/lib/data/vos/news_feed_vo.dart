import 'package:json_annotation/json_annotation.dart';

part 'news_feed_vo.g.dart';

@JsonSerializable()
class NewsFeedVO {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "profile_picture")
  String? profilePicture;

  @JsonKey(name: "user_name")
  String? userName;

  @JsonKey(name: "post_image")
  String? postImage;

  NewsFeedVO({
    this.id,
    this.description,
    this.profilePicture,
    this.userName,
    this.postImage,
  });

  factory NewsFeedVO.fromJson(Map<String, dynamic> json) =>
      _$NewsFeedVOFromJson(json);

  Map<String, dynamic> toJson() => _$NewsFeedVOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NewsFeedVO &&
      other.id == id &&
      other.description == description &&
      other.profilePicture == profilePicture &&
      other.userName == userName &&
      other.postImage == postImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      description.hashCode ^
      profilePicture.hashCode ^
      userName.hashCode ^
      postImage.hashCode;
  }

  @override
  String toString() {
    return 'NewsFeedVO(id: $id, description: $description, profilePicture: $profilePicture, userName: $userName, postImage: $postImage)';
  }
}
