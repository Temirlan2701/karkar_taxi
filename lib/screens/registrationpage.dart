import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_app/brand_colors.dart';
import 'package:taxi_app/screens/loginpage.dart';
import 'package:taxi_app/screens/mainpage.dart';
import 'package:taxi_app/widgets/ProgressDialog.dart';
import 'package:taxi_app/widgets/TaxiButton.dart';

class RegistrationPage extends StatefulWidget {

  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
        content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Регистрация...',),
    );

    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).catchError((ex){
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    })).user;


    Navigator.pop(context);
    if(user != null){
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');
      Map userMap = {
        'fullname' : fullNameController.text,
        'email' : emailController.text,
        'phone' : phoneController.text,
      };
      newUserRef.set(userMap);

      Navigator.pushNamedAndRemoveUntil(context, Mainpage.id, (route) => false);
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

                Text('Создать аккаунт водителя',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      ///Name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration:  InputDecoration(
                          labelText: 'Имя',
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

                      ///Email
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

                      ///Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:  InputDecoration(
                          labelText: 'Номер телефона',
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

                      ///Password
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
                        title: 'Создать аккаунт',
                        color: BrandColors.colorGreen,
                        onPressed: () async {

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(fullNameController.text.length < 3){
                            showSnackBar('Пожалуйста, введите ваше имя');
                            return;
                          }

                          if(phoneController.text.length < 10){
                            showSnackBar('Пожалуйста, введите действительный номер телефона');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Пожалуйста, введите действительный email адрес');
                            return;
                          }

                          if(passwordController.text.length < 8){
                            showSnackBar('Пароль должен состоять из 8 символов');
                            return;
                          }
                          registerUser();

                        },
                      )
                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                    child: Text('У вас уже имеется аккаунт водителя? Войти')),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
