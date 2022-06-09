import 'package:firebase_installations/firebase_installations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/data/models/authentication_model.dart';
import 'package:social_media/data/models/authentication_model_impl.dart';
import 'package:social_media/fcm/fcm_service.dart';
import 'package:social_media/pages/login_page.dart';
import 'package:social_media/pages/news_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForNotification();

  var firebaseInstallationId = await FirebaseInstallations.id;
  print('Firebase Installation Id ===> $firebaseInstallationId');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationModel authenticationModel = AuthenticationModelImpl();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (authenticationModel.isLoggedIn())
          ? const NewsFeedPage()
          : const LoginPage(),
      //home: TempHomePage(),
    );
  }
}
