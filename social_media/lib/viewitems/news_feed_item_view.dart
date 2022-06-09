import 'package:flutter/material.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/images.dart';
import 'package:social_media/widgets/profile_image_view.dart';

class NewsFeedItemView extends StatelessWidget {
  final NewsFeedVO? mNewsFeed;
  final Function(int) onTapDelete;
  final Function(int) onTapEdit;

  const NewsFeedItemView({
    Key? key,
    required this.mNewsFeed,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImageView(
              profileImage: mNewsFeed?.profilePicture ?? "",
            ),
            const SizedBox(
              width: MARGIN_MEDIUM_2,
            ),
            NameLocationAndTimeAgoView(
              userName: mNewsFeed?.userName ?? "",
            ),
            const Spacer(),
            MoreButtonView(
              onTapDelete: () {
                onTapDelete(mNewsFeed?.id ?? 0);
              },
              onTapEdit: () {
                onTapEdit(mNewsFeed?.id ?? 0);
              },
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Visibility(
          visible: ((mNewsFeed?.postImage ?? "").isNotEmpty),
          child: PostImageView(
            postImage: mNewsFeed?.postImage ?? "",
          ),
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PostDescriptionView(
          description: mNewsFeed?.description ?? "",
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Row(
          children: const [
            Text(
              "See Comments",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Icon(
              Icons.mode_comment_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: MARGIN_MEDIUM,
            ),
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
            )
          ],
        )
      ],
    );
  }
}

class PostDescriptionView extends StatelessWidget {
  final String description;

  const PostDescriptionView({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(
        fontSize: TEXT_REGULAR,
        color: Colors.black,
      ),
    );
  }
}

class PostImageView extends StatelessWidget {
  final String postImage;

  const PostImageView({
    Key? key,
    required this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
      child: FadeInImage(
        height: 200,
        width: double.infinity,
        placeholder: const NetworkImage(
          NETWORK_IMAGE_POST_PLACEHOLDER,
        ),
        image: NetworkImage(
          postImage,
        ),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

class MoreButtonView extends StatelessWidget {
  final Function onTapDelete;
  final Function onTapEdit;

  const MoreButtonView({
    Key? key,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onTapEdit();
          },
          child: const Text("Edit"),
          value: 1,
        ),
        PopupMenuItem(
          onTap: () {
            onTapDelete();
          },
          child: const Text("Delete"),
          value: 2,
        )
      ],
    );
  }
}

class NameLocationAndTimeAgoView extends StatelessWidget {
  final String userName;

  const NameLocationAndTimeAgoView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: MARGIN_SMALL,
            ),
            const Text(
              "- 2 hours ago",
              style: TextStyle(
                fontSize: TEXT_SMALL,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        const Text(
          "Paris",
          style: TextStyle(
            fontSize: TEXT_SMALL,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
