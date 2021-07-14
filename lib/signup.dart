import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_widgets.dart';
import 'loginpage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _verticalGroupValue = "Male";
  TextEditingController _usernamecontroller = new TextEditingController();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _confirmpasswordcontroller =
      new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _isAllValid;
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _success;
  String _userEmail;
  String TAG = "Signup";

  SharedPreferences prefs;

  //stored uemail & Password
  static String USER_PASSWORD = "password";
  static String USER_EMAIL = "user_email";

  //FireBAse VAriables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentuser;
  static String FBASE_USERKEY = "firebase_user_key";

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF19232d),
        //height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_appLogo(), _signupCard(context)],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 200,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _signupCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Create an Account',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Enter your details to create new account',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _usernameTextField(),
                  SizedBox(height: 10),
                  _emailCreateTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  _genderRow(),
                  SizedBox(
                    height: 25,
                  ),
                  _passwordTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  _confirmPasswordTextField(),
                  SizedBox(
                    height: 25,
                  ),
                  _signupButton(),
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
    );
  }

  Widget _signupButton() {
    return Center(
      child: RaisedButton(
          onPressed: () {
            _isAllValid = _validationForSignUp();
            if (_isAllValid == 'true') {
              showLoaderDialog(context);
              _signUpApicall();
              /* Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));*/
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(_isAllValid),
              ));
            }
          },
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 20, right: 20, top: 15),
            child: Text('SignUp',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins-Medium')),
          )),
    );
  }

  Widget _usernameTextField() {
    return TextField(
      controller: _usernamecontroller,
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

  Widget _emailCreateTextField() {
    return TextField(
      controller: _emailcontroller,
      decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: IconButton(
            icon: Image.asset(
              'assets/images/grey_email.png',
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
    return TextField(
      controller: _passwordcontroller,
      obscureText: _obscureText,
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
    );
  }

  Widget _confirmPasswordTextField() {
    return TextField(
      obscureText: _obscureText2,
      controller: _confirmpasswordcontroller,
      decoration: InputDecoration(
          hintText: 'Confirm Password',
          prefixIcon: IconButton(
            icon: Image.asset(
              'assets/images/password_grey.png',
              width: 20.0,
              height: 20.0,
            ),
            onPressed: () {
              _toggle2();
            },
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

  Widget _emailTextField() {
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.grey,
          filled: true,
          hintText: 'Email Address',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent)),
          focusColor: Colors.black,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }

  Widget _dontHaveAccountRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Already have an account?",
      ),
      SizedBox(
        width: 5,
      ),
      GestureDetector(
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Text(
            "Login",
          )),
    ]);
  }

  Widget _genderRow() {
    List<String> _status = ["Male", "Female"];

    return Row(
      children: [
        Text(
          "Gender",
        ),
        SizedBox(
          width: 20,
        ),
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: _verticalGroupValue,
          onChanged: (value) => setState(() {
            _verticalGroupValue = value;
          }),
          items: _status,
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
    );
  }

  String _validationForSignUp() {
    if (_usernamecontroller.text.isEmpty) {
      return "Username can't be empty";
    } else if (!_validationEmail()) {
      return "Email is not valid or empty";
    } else if (!_validatePassoword()) {
      return "Password is not valid or empty";
    } else if (!_validateConfirmPassword()) {
      return 'confirm password not same as password or empty';
    } else {
      return 'true';
    }
  }

  bool _validationEmail() {
    if (_emailcontroller.text.isEmpty ||
        _emailcontroller.text == null ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailcontroller.text)) {
      return false;
    } else {
      return true;
    }
  }

  bool _validatePassoword() {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(_passwordcontroller.text);
  }

  bool _validateConfirmPassword() {
    if (_passwordcontroller.text != _confirmpasswordcontroller.text) {
      return false;
    } else {
      return true;
    }
  }

  Future _signUpApicall() async {
    prefs = await SharedPreferences.getInstance();
    String fcmid = prefs.getString('fcm_id');
    String gender;
    if (_verticalGroupValue == 'Male') {
      gender = "0";
    } else {
      gender = "1";
    }

    if (fcmid.isNotEmpty && fcmid != null && gender != null) {
      try {
        bool issignup =
            await _signup(_emailcontroller.text, _passwordcontroller.text);
      }
      // print(userModel.userId);
      catch (Exception) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something Went wrong 22'),
        ));
        print(Exception);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something Went wrong 33'),
      ));
    }
  }

  Future<bool> _signup(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    if (userCredential != null) {
      var uid = userCredential.user.uid;
      prefs.setBool("signin", true);
      prefs.setString(USER_EMAIL, email);
      prefs.setString(USER_PASSWORD, password);
      prefs.setString(FBASE_USERKEY, _auth.currentUser.uid);
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).popUntil((route) => route.isFirst);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
      return true;
    } else {
      return false;
    }
  }
}
