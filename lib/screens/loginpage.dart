import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_app/brand_colors.dart';
import 'package:taxi_app/screens/mainpage.dart';
import 'package:taxi_app/screens/registrationpage.dart';
import 'package:taxi_app/widgets/ProgressDialog.dart';
import 'package:taxi_app/widgets/TaxiButton.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Вход в систему',),
    );

  final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).catchError((ex){
    Navigator.pop(context);
    PlatformException thisEx = ex;
    showSnackBar(thisEx.message);
  })).user;
  if(user != null){

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');

    userRef.once().then((DataSnapshot snapshot) {

      if(snapshot.value != null) {

        Navigator.pushNamedAndRemoveUntil(context, Mainpage.id, (route) => false);
      }
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage('assets/images/logo.png'),
                ),

                SizedBox(height: 40,),

                Text('Войти как водитель',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:  InputDecoration(
                          labelText: 'Пароль',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      TaxiButton(
                        title: 'Войти',
                        color: BrandColors.colorGreen,
                        onPressed: () async {

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Пожалуйста, введите действительный email адресс');
                            return;
                          }

                          if(passwordController.text.length < 8){
                            showSnackBar('Пароль должен состоять из 8 символов');
                            return;
                          }

                          login();

                        },
                      )
                    ],
                  ),
                ),

                FlatButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                  },
                    child: Text('Создать аккаунт водителя')),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


