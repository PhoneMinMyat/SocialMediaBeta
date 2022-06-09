import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/register_bloc.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/utils/extensions.dart';
import 'package:social_media/widgets/label_and_textfield_view.dart';
import 'package:social_media/widgets/loading_view.dart';
import 'package:social_media/widgets/or_view.dart';
import 'package:social_media/widgets/primary_button_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        body: Selector<RegisterBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) => Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: LOGIN_SCREEN_TOP_PADDING,
                    bottom: MARGIN_LARGE,
                    left: MARGIN_XLARGE,
                    right: MARGIN_XLARGE,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        LBL_REGISTER,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TEXT_BIG,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                          label: LBL_EMAIL,
                          hint: HINT_EMAIL,
                          onChanged: (email) => bloc.onEmailChanged(email),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                          label: LBL_USER_NAME,
                          hint: HINT_USER_NAME,
                          onChanged: (userName) =>
                              bloc.onUserNameChanged(userName),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                          label: LBL_PASSWORD,
                          hint: HINT_PASSWORD,
                          onChanged: (password) =>
                              bloc.onPasswordChanged(password),
                          isSecure: true,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      const UserProfileSectionView(),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) => TextButton(
                          onPressed: () {
                            bloc
                                .onTapRegister()
                                .then((value) => Navigator.pop(context))
                                .catchError((error) => showSnackBarWithMessage(
                                    context, error.toString()));
                          },
                          child: const PrimaryButtonView(
                            label: LBL_REGISTER,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const ORView(),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const LoginTriggerView()
                    ],
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
      ),
    );
  }
}

class UserProfileSectionView extends StatelessWidget {
  const UserProfileSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterBloc>(
      builder: (context, bloc, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            LBL_USER_PROFILE_PICTURE,
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Container(
            padding: const EdgeInsets.all(MARGIN_MEDIUM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
              border: Border.all(color: Colors.black45, width: 1),
            ),
            child: Stack(
              children: [
                Container(
                  child: (bloc.choseImageFile == null)
                      ? GestureDetector(
                          child: SizedBox(
                            height: 300,
                            child: Image.network(
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
          )
        ],
      ),
    );
  }
}

class LoginTriggerView extends StatelessWidget {
  const LoginTriggerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LBL_ALREADY_HAVE_AN_ACCOUNT,
        ),
        const SizedBox(width: MARGIN_SMALL),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            LBL_LOGIN,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
