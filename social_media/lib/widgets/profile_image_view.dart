import 'package:flutter/material.dart';
import 'package:social_media/resources/dimens.dart';

class ProfileImageView extends StatelessWidget {
  final String profileImage;

  const ProfileImageView({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        profileImage,
      ),
      radius: MARGIN_LARGE,
    );
  }
}
