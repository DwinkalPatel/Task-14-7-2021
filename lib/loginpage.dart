import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flutter/signup.dart';

import 'Welcome.dart';
import 'common_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  var _formKeyforLoginCard = GlobalKey<FormState>();
  var _formKeyforForgot = GlobalKey<FormState>();
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();

  TextEditingController _forgot_emailController = new TextEditingController();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _oldpasscontroller = new TextEditingController();
  TextEditingController _newpasscontroller = new TextEditingController();
  TextEditingController _retypepasscontroller = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  SharedPreferences prefs;
  static String SIGNIN_RESULT = "signinresult";
  bool signinrslt = false;
  static String FIREBASEAUTH_UID = "firebaseauth_uid";

  //stored uemail & Password
  static String USER_PASSWORD = "password";
  static String USER_EMAIL = "user_email";

  //FireBAse VAriables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentuser;
  static String FBASE_USERKEY = "firebase_user_key";

  String _TAG = "LoginPage";
  bool _obscureText4 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _submit2(GlobalKey<FormState> formkey) {
    final isValid = formkey.currentState.validate();
    formkey.currentState.save();
    if (isValid) {
      return true;
    } else {
      return false;
    }
  }

  void toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void toggle3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  void _submit() {
    final isValid = _formKeyforLoginCard.currentState.validate();

    if (isValid) {
      showLoaderDialog(context);
      _loginApiCall();
      //}
    }
    _formKeyforLoginCard.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Color(0xFF19232d),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),

              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 15,
              ),
              _loginCard(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Form(
                key: _formKeyforLoginCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('Login'),
                    SizedBox(
                      height: 20,
                    ),
                    _usernameTextField(),
                    SizedBox(height: 10),
                    _passwordTextField(),
                    SizedBox(
                      height: 15,
                    ),
                    _forgotPassword(context),
                    SizedBox(
                      height: 25,
                    ),
                    _loginButton(),
                    SizedBox(
                      height: 15,
                    ),
                    _dontHaveAccountRow(),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Center(
      child: RaisedButton(
          onPressed: () {
            _submit();
          },
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 20, right: 20, top: 15),
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          print('onTap');
        },
        child: Text(
          'Forgot Password ?',
        ),
      ),
    );
  }

  Widget _usernameTextField() {
    return TextFormField(
      controller: _emailcontroller,
      onFieldSubmitted: (value) {},
      validator: (value) {
        if (value.isEmpty ||
            value == null ||
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return 'Enter a valid email!';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: 'Username',
          prefixIcon: IconButton(
            icon: Image.asset(
              'assets/images/person_blackoutline.png',
              width: 20.0,
              height: 20.0,
            ),
            onPressed: null,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey)),
          focusColor: Colors.black,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      onFieldSubmitted: (value) {},
      controller: _passwordcontroller,
      validator: (value) {
        String pattern =
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        if (value.isEmpty ||
            value == null ||
            !RegExp(pattern).hasMatch(value)) {
          return 'Enter a valid Password!';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: IconButton(
            icon: Image.asset(
              'assets/images/password_grey.png',
              width: 20.0,
              height: 20.0,
            ),
            onPressed: () {
              _toggle();
            },
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey)),
          focusColor: Colors.black,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
      obscureText: _obscureText,
    );
  }

  Widget _emailTextField() {
    return Form(
      key: _formKeyforForgot,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty ||
              value == null ||
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return 'Enter a valid email!';
          }
          return null;
        },
        controller: _forgot_emailController,
        decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(.2),
            filled: true,
            hintText: 'Email Address',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent)),
            focusColor: Colors.black,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Widget _dontHaveAccountRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Don/'t have an account?",
      ),
      SizedBox(
        width: 5,
      ),
      GestureDetector(
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text(
            "Sign Up",
          )),
    ]);
  }

  Future _loginApiCall() async {
    String is_sm_connected = "0";
    String fcmid = prefs.getString('fcm_id');

    if (fcmid.isNotEmpty && fcmid != null) {
      try {
        await _signinwithfirebase(
            _emailcontroller.text, _passwordcontroller.text);
      } catch (Exception) {
        snackbar(_scaffoldKey, 'Something Went wrong');
        print(Exception);
      }
    } else {
      snackbar(_scaffoldKey, 'Something Went wrong');
    }
  }

  Future _signinwithfirebase(String emailid, String password) async {
    print('email_password ::: ${emailid} ${password}');
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailid, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        snackbar(_scaffoldKey, 'No user found for that email.');
      } else {
        print(e.message);
        snackbar(_scaffoldKey, e.message);
      }
    }

    if (userCredential != null) {
      var uid = userCredential.user.uid;
      prefs.setString("auth_id", uid);
      prefs.setBool(SIGNIN_RESULT, true);

      prefs.setBool('signin', true);
      prefs.setString(USER_EMAIL, emailid);
      prefs.setString(USER_PASSWORD, password);
      prefs.setString(FBASE_USERKEY, _auth.currentUser.uid);
      snackbar(_scaffoldKey, 'Login SuccessFully');

      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      });
    }

    bool issigninresult = prefs.getBool(SIGNIN_RESULT);
    if (issigninresult) {
      signinrslt = true;
    }
    return signinrslt;
  }

  /*Future<UserCredential> _signupWithFirebase(String emailid, String password,
      ) async {

    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailid, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        snackbar(_scaffoldKey, 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        snackbar(_scaffoldKey, 'Authentication Failed');
      }
    } catch (e) {
      print(e);
      snackbar(_scaffoldKey, 'Something Went Wrong');
    }
    if (userCredential.user.uid != null) {
      prefs.setBool(SIGNIN_RESULT, true);
      prefs.setString('key', FIREBASEAUTH_UID);
      prefs.setBool('signin', true);
      prefs.setString(USER_EMAIL, emailid);
      prefs.setString(USER_PASSWORD, password);
      prefs.setString(FBASE_USERKEY, _auth.currentUser.uid);
      snackbar(_scaffoldKey, 'Login SuccessFully');

      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      });
      //_addDataOnFirebase(userCredential.user.uid);
    } else {
      snackbar(_scaffoldKey, 'Authentication Failed');
      prefs.setBool(SIGNIN_RESULT, false);
    }
    return userCredential;
  }

*/
  Future getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
