import 'dart:async';
import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/login_screen/widgets/header_login.dart';
import 'package:cafe/login_screen/widgets/push_to_signup.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

StreamSubscription<DocumentSnapshot> subscription;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone, password;

  List<String> cafenameList = new List();
  List<int> cafeReviews = new List();
  List<int> starsAvrage = new List();

  String nameForSignup;

  String phoneForSignup;

  String passwordForSignup;

  void getAllReviews() async {
    int count = 0;
    cafeReviews = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('cafes').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      cafeReviews.add(data['reviews'].length);
      int sum = 0;
      for (var i = 0; i < cafeReviews[count]; i++) {
        //should sum all the values
        sum += data['reviews'][i]['stars'];
      }
      starsAvrage.add(sum);
      count++;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllReviews();
  }

  int control = 0;
  bool login = true;
  bool signup = false;
  void showToast() {
    setState(() {
      if (control == 0) {
        login = true;
        signup = false;
        control = 1;
      } else {
        login = false;
        signup = true;
        control = 0;
      }
    });
  }

  var phoneText = TextEditingController();
  var passwordText = TextEditingController();
  var phoneTextReg = TextEditingController();
  var passwordTextReg = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocusReg = FocusNode();
  final FocusNode _passwordFocusReg = FocusNode();
  final FocusNode _nameFocusReg = FocusNode();
  @override
  Widget build(BuildContext context) {
    if (phoneTextReg.text != '') {
      phoneText.text = phoneTextReg.text;
      passwordText.text = passwordTextReg.text;
    }

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Visibility(
            visible: login,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HeaderLogin(width: width),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.7,
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(196, 153, 198, 0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: phoneText,
                                    textAlign: TextAlign.end,
                                    onChanged: (val) {
                                      setState(() {
                                        phone = val;
                                      });
                                    },
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'رقم الجوال',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'topaz')),
                                    focusNode: _phoneFocus,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          context, _phoneFocus, _passwordFocus);
                                    }),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    focusNode: _passwordFocus,
                                    textInputAction: TextInputAction.done,
                                    controller: passwordText,
                                    textAlign: TextAlign.end,
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'كلمة المرور',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'topaz'),
                                    ),
                                    onFieldSubmitted: (term) async {
                                      _onsubmit();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  2,
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(49, 39, 79, 0.8),
                    ),
                    child: Builder(
                      builder: (context) => InkWell(
                        onTap: () async {
                          _onsubmit();
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                        child: Center(
                          child: Text(
                            "دخول",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'topaz',
                                fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                PushToSignUp(
                  showToast: showToast,
                  change: 'تسجيل',
                ),
              ],
            ),
          ),
          Visibility(
            visible: signup,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    HeaderLogin(),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.8,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(143, 14, 251, .2),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey[100]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      focusNode: _nameFocusReg,
                                      textAlign: TextAlign.end,
                                      onChanged: (val) {
                                        setState(() {
                                          nameForSignup = val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'الأسم',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'topaz'),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        _fieldFocusChange(context,
                                            _nameFocusReg, _phoneFocusReg);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[100],
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      focusNode: _phoneFocusReg,
                                      controller: phoneTextReg,
                                      textAlign: TextAlign.end,
                                      onChanged: (val) {
                                        setState(() {
                                          phoneForSignup = val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'رقم الجوال',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'topaz'),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        _fieldFocusChange(context,
                                            _phoneFocusReg, _passwordFocusReg);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      focusNode: _passwordFocusReg,
                                      controller: passwordTextReg,
                                      textAlign: TextAlign.end,
                                      onChanged: (val) {
                                        passwordForSignup = val;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'كلمة المرور',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'topaz'),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        _onSubmitReg();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            2,
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(49, 39, 79, 0.8),
                              ),
                              child: Builder(
                                builder: (context) => InkWell(
                                  onTap: () async {
                                    _onSubmitReg();
                                  },
                                  splashColor: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Center(
                                    child: Text(
                                      "تسجيل",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'topaz',
                                          fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PushToSignUp(
                            showToast: showToast,
                            change: 'دخول',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _onsubmit() async {
    var info, dbID;
    final QuerySnapshot userinfo = await Firestore.instance
        .collection('users')
        .where("password", isEqualTo: password)
        .where("phone", isEqualTo: phone)
        .getDocuments();
    final List<DocumentSnapshot> documents = userinfo.documents;
    if (documents.length == 1) {
      documents.forEach((data) {
        info = UserInfo(
          name: data['name'],
          phone: data['phone'],
          id: data.documentID,
          reviewsCount: cafeReviews,
          starsAvrage: starsAvrage,
        );
        dbID = BookingDB(
          data.documentID,
        );
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return CafeList(info, dbID);
          },
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'خطأ في تسجيل الدخول',
          textAlign: TextAlign.end,
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }

  _onSubmitReg() async {
    final QuerySnapshot userinfo = await Firestore.instance
        .collection('users')
        .where("phone", isEqualTo: phoneForSignup)
        .getDocuments();
    final List<DocumentSnapshot> documents = userinfo.documents;
    if (documents.length == 0) {
      await SigninFiresotre()
          .addUser(nameForSignup, phoneForSignup, passwordForSignup);
      setState(() {
        control = 0;
        showToast();
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'رقم الجوال مسجل',
          textAlign: TextAlign.end,
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
