import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/add_new_post_bloc..dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/widgets/loading_view.dart';
import 'package:social_media/widgets/primary_button_view.dart';
import 'package:social_media/widgets/profile_image_view.dart';

class AddNewPostPage extends StatelessWidget {
  final int? newsFeedId;

  const AddNewPostPage({
    Key? key,
    this.newsFeedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsFeedId: newsFeedId),
      child: Selector<AddNewPostBloc, bool>(
        selector: (context, bloc) => bloc.isLoading,
        builder: (context, isLoading, child) => Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: false,
                title: Container(
                    margin: const EdgeInsets.only(
                      left: MARGIN_MEDIUM,
                    ),
                    child: Selector<AddNewPostBloc, bool>(
                      selector: (context, bloc) => bloc.isInEditMode,
                      builder: (context, isEdit, child) => Text(
                        (isEdit) ? "Edit Post" : "Add New Post",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TEXT_HEADING_1X,
                          color: Colors.black,
                        ),
                      ),
                    )),
                elevation: 0.0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: MARGIN_XLARGE,
                  ),
                ),
              ),
              body: Container(
                margin: const EdgeInsets.only(
                  top: MARGIN_XLARGE,
                ),
                padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      ProfileImageAndNameView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      AddNewPostTextFieldView(),
                      SizedBox(
                        height: MARGIN_MEDIUM_2,
                      ),
                      PostDescriptionErrorView(),
                      SizedBox(
                        height: MARGIN_MEDIUM_2,
                      ),
                      PostImageView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      PostButtonView(),
                      SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black12,
                child: const Center(
                  child: LoadingView(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostImageView extends StatelessWidget {
  const PostImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Container(
        padding: const EdgeInsets.all(MARGIN_MEDIUM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [
            Container(
              child: (bloc.choseImageFile == null)
                  ? GestureDetector(
                      child: SizedBox(
                        height: 300,
                        child: (bloc.isInEditMode && (bloc.imageUrl != null && (bloc.imageUrl?.isNotEmpty ?? false)))
                            ? Image.network(bloc.imageUrl ?? "")
                            : Image.network(
                                "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640",
                              ),
                      ),
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          bloc.onImageChosen(File(image.path));
                        }
                      },
                    )
                  : SizedBox(
                      height: 300,
                      child: Image.file(
                        bloc.choseImageFile ?? File(""),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: bloc.choseImageFile != null ||
                    (bloc.imageUrl?.isNotEmpty ?? false),
                child: GestureDetector(
                  onTap: () {
                    bloc.onTapDeleteImage();
                  },
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {
  const PostDescriptionErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isAddNewPostError,
        child: const Text(
          "Post should not be empty",
          style: TextStyle(
            color: Colors.red,
            fontSize: TEXT_REGULAR,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PostButtonView extends StatelessWidget {
  const PostButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => GestureDetector(
        onTap: () {
          bloc.onTapAddNewPost().then((value) {
            Navigator.pop(context);
          });
        },
        child:  PrimaryButtonView(
          label: LBL_POST,
           themeColor: bloc.themeColor,
        ),
      ),
    );
  }
}

class ProfileImageAndNameView extends StatelessWidget {
  const ProfileImageAndNameView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Row(
        children: [
          ProfileImageView(
            profileImage: bloc.profilePicture,
          ),
          const SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
          Text(
            bloc.userName,
            style: const TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewPostTextFieldView extends StatelessWidget {
  const AddNewPostTextFieldView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => SizedBox(
        height: ADD_NEW_POST_TEXTFIELD_HEIGHT,
        child: TextField(
          maxLines: 24,
          controller: TextEditingController(text: bloc.newPostDescription),
          onChanged: (text) {
            bloc.onTextChanged(text);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                MARGIN_MEDIUM,
              ),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            hintText: "What's on your mind?",
          ),
        ),
      ),
    );
  }
}
