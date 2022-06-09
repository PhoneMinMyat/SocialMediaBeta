import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/news_feed_bloc.dart';
import 'package:social_media/pages/add_new_post_page.dart';
import 'package:social_media/pages/login_page.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/utils/extensions.dart';
import 'package:social_media/viewitems/news_feed_item_view.dart';

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: const Text(
              "Social",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            Consumer<NewsFeedBloc>(
              builder: (context, bloc, child) => GestureDetector(
                onTap: () {
                  bloc.onTapLogOut().then(
                      (_) => navigateToScreen(context, const LoginPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: MARGIN_LARGE,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: MARGIN_LARGE,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            /// Navigate to Add New Post Page
            _navigateToAddNewPostPage(context);

            
             //FirebaseCrashlytics.instance.crash();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  mNewsFeed: bloc.newsFeedList?[index],
                  onTapDelete: (newsFeedId) {
                    bloc.onTapPostDelete(newsFeedId);
                  },
                  onTapEdit: (newsFeedId) {
                    Future.delayed(const Duration(milliseconds: 1000))
                        .then((value) {
                      _navigateToEditPostPage(context, newsFeedId);
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeedList?.length ?? 0,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddNewPostPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewPostPage(),
      ),
    );
  }

  void _navigateToEditPostPage(BuildContext context, int newsFeedId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(
          newsFeedId: newsFeedId,
        ),
      ),
    );
  }
}
