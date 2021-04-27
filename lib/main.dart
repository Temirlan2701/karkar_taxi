import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/dataprovider/appdata.dart';
import 'package:taxi_app/screens/loginpage.dart';
import 'dart:io';

import 'package:taxi_app/screens/mainpage.dart';
import 'package:taxi_app/screens/registrationpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
            gcmSenderID: '297855924061',
            databaseURL: 'https://geetaxi-41ac9-default-rtdb.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:146240457350:android:9c0b4e264cde6243649f07',
            apiKey: 'AIzaSyDOXL_Kq6QrDQJiqJdZDpmlMCFu1O6AZRQ',
            databaseURL: 'https://karkartaxi-default-rtdb.firebaseio.com',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: Mainpage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          Mainpage.id: (context) => Mainpage(),
        },
      ),
    );
  }
}
