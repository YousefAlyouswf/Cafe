import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/login_screen/widgets/header_login.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpWidget extends StatefulWidget {
  ProgressDialog pr;
  String phone;

  TextEditingController phoneTextReg = TextEditingController();
  TextEditingController passwordTextReg = TextEditingController();
  Function _fieldFocusChange;

  FocusNode _phoneFocusReg = FocusNode();
  FocusNode _passwordFocusReg = FocusNode();
  FocusNode _nameFocusReg = FocusNode();
  String nameForSignup;
  String phoneForSignup;

  String passwordForSignup;

  String errorMsg = '';

  SignUpWidget(
    this._fieldFocusChange,
    this._passwordFocusReg,
    this._nameFocusReg,
    this._phoneFocusReg,
    this.errorMsg,
    this.phoneTextReg,
    this.passwordTextReg,
    this.phoneForSignup,
    this.passwordForSignup,
    this.phone,
    this.nameForSignup,
    this.pr,
  );
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState(
        this._fieldFocusChange,
        this._passwordFocusReg,
        this._nameFocusReg,
        this._phoneFocusReg,
        this.errorMsg,
        this.phoneTextReg,
        this.passwordTextReg,
        this.phoneForSignup,
        this.passwordForSignup,
        this.phone,
        this.nameForSignup,
        this.pr,
      );
}

class _SignUpWidgetState extends State<SignUpWidget> {
  ProgressDialog pr;
  String phone;

  TextEditingController phoneTextReg = TextEditingController();
  TextEditingController passwordTextReg = TextEditingController();

  FocusNode _phoneFocusReg = FocusNode();
  FocusNode _passwordFocusReg = FocusNode();
  FocusNode _nameFocusReg = FocusNode();
  String nameForSignup;

  String phoneForSignup;
  Function _fieldFocusChange;
  String passwordForSignup;

  String errorMsg = '';

  _SignUpWidgetState(
    this._fieldFocusChange,
    this._passwordFocusReg,
    this._nameFocusReg,
    this._phoneFocusReg,
    this.errorMsg,
    this.phoneTextReg,
    this.passwordTextReg,
    this.phoneForSignup,
    this.passwordForSignup,
    this.phone,
    this.nameForSignup,
    this.pr,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            HeaderLogin(),
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
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
                                bottom: BorderSide(color: Colors.grey[100]),
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
                                _fieldFocusChange(
                                    context, _nameFocusReg, _phoneFocusReg);
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
                                _fieldFocusChange(
                                    context, _phoneFocusReg, _passwordFocusReg);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Builder(
                              builder: (context) => TextFormField(
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
                                onFieldSubmitted: (value) async {
                                  try {
                                    if (nameForSignup.length < 2) {
                                      setState(() {
                                        errorMsg =
                                            'يجب كتابة الأسم بالشكل الصحيح';
                                      });
                                    } else if (phoneForSignup.length < 10) {
                                      setState(() {
                                        errorMsg =
                                            'رقم الجوال يجب ان يكون 10 خانات';
                                      });
                                    } else if (passwordForSignup.length < 6) {
                                      setState(() {
                                        errorMsg =
                                            'كلمة المرور يجب ان تكون 6 او اكثر';
                                      });
                                    } else {
                                      setState(() {
                                        errorMsg = '';
                                      });
                                    }
                                    if (errorMsg == '') {
                                      pr.show();
                                      final QuerySnapshot userinfo =
                                          await Firestore
                                              .instance
                                              .collection('users')
                                              .where("phone",
                                                  isEqualTo: phoneForSignup)
                                              .getDocuments();
                                      final List<DocumentSnapshot> documents =
                                          userinfo.documents;
                                      if (documents.length == 0) {
                                        await SigninFiresotre().addUser(
                                            nameForSignup,
                                            phoneForSignup,
                                            passwordForSignup);

                                        //------------------
                                        var info, dbID;
                                        final QuerySnapshot userinfo =
                                            await Firestore.instance
                                                .collection('users')
                                                .where("phone",
                                                    isEqualTo: phoneForSignup)
                                                .getDocuments();
                                        final List<DocumentSnapshot> documents =
                                            userinfo.documents;

                                        documents.forEach((data) {
                                          info = UserInfo(
                                            name: data['name'],
                                            phone: data['phone'],
                                            id: data.documentID,
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
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            'رقم الجوال مسجل',
                                            textAlign: TextAlign.end,
                                          ),
                                          duration: Duration(seconds: 3),
                                        ));
                                        pr.hide();
                                      }
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          errorMsg,
                                          textAlign: TextAlign.end,
                                        ),
                                        duration: Duration(seconds: 3),
                                      ));
                                      pr.hide();
                                    }
                                  } catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "خطأ في أدخال البيانات",
                                        textAlign: TextAlign.end,
                                      ),
                                      duration: Duration(seconds: 3),
                                    ));
                                    pr.hide();
                                  }
                                },
                              ),
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
                            try {
                              if (nameForSignup.length < 2) {
                                setState(() {
                                  errorMsg = 'يجب كتابة الأسم بالشكل الصحيح';
                                });
                              } else if (phoneForSignup.length < 10) {
                                setState(() {
                                  errorMsg = 'رقم الجوال يجب ان يكون 10 خانات';
                                });
                              } else if (passwordForSignup.length < 6) {
                                setState(() {
                                  errorMsg =
                                      'كلمة المرور يجب ان تكون 6 او اكثر';
                                });
                              } else {
                                setState(() {
                                  errorMsg = '';
                                });
                              }
                              if (errorMsg == '') {
                                pr.show();
                                final QuerySnapshot userinfo = await Firestore
                                    .instance
                                    .collection('users')
                                    .where("phone", isEqualTo: phoneForSignup)
                                    .getDocuments();
                                final List<DocumentSnapshot> documents =
                                    userinfo.documents;
                                if (documents.length == 0) {
                                  await SigninFiresotre().addUser(nameForSignup,
                                      phoneForSignup, passwordForSignup);

                                  //------------------
                                  var info, dbID;
                                  final QuerySnapshot userinfo = await Firestore
                                      .instance
                                      .collection('users')
                                      .where("phone", isEqualTo: phoneForSignup)
                                      .getDocuments();
                                  final List<DocumentSnapshot> documents =
                                      userinfo.documents;

                                  documents.forEach((data) {
                                    info = UserInfo(
                                      name: data['name'],
                                      phone: data['phone'],
                                      id: data.documentID,
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
                                      'رقم الجوال مسجل',
                                      textAlign: TextAlign.end,
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                  pr.hide();
                                }
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    errorMsg,
                                    textAlign: TextAlign.end,
                                  ),
                                  duration: Duration(seconds: 3),
                                ));
                                pr.hide();
                              }
                            } catch (e) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "خطأ في أدخال البيانات",
                                  textAlign: TextAlign.end,
                                ),
                                duration: Duration(seconds: 3),
                              ));
                              pr.hide();
                            }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
