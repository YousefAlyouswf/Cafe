import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'header_login.dart';

class LoginWidget extends StatefulWidget {
  ProgressDialog pr;
  String phone;
  Function _fieldFocusChange;
  TextEditingController phoneText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController phoneTextReg = TextEditingController();
  TextEditingController passwordTextReg = TextEditingController();

  FocusNode _phoneFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  LoginWidget(
    this.pr,
    this.phone,
    this.phoneText,
    this.passwordText,
    this._passwordFocus,
    this._phoneFocus,
    this._fieldFocusChange,
  );
  @override
  _LoginWidgetState createState() => _LoginWidgetState(
        this.pr,
        this.phone,
        this.phoneText,
        this.passwordText,
        this._passwordFocus,
        this._phoneFocus,
        this._fieldFocusChange,
      );
}

class _LoginWidgetState extends State<LoginWidget> {
  ProgressDialog pr;
  String phone;

  TextEditingController phoneText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController phoneTextReg = TextEditingController();
  TextEditingController passwordTextReg = TextEditingController();
  Function _fieldFocusChange;
  FocusNode _phoneFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();


  String password;

  _LoginWidgetState(
    this.pr,
    this.phone,
    this.phoneText,
    this.passwordText,
    this._passwordFocus,
    this._phoneFocus,
    this._fieldFocusChange,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderLogin(),
         
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FadeAnimation(
                  1,
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
                                      color: Colors.grey, fontFamily: 'topaz')),
                              focusNode: _phoneFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _phoneFocus, _passwordFocus);
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Builder(
                            builder: (context) => TextFormField(
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
                                    color: Colors.grey, fontFamily: 'topaz'),
                              ),
                              onFieldSubmitted: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isLogin', true);
                                pr.show();
                                var info, dbID;
                                final QuerySnapshot userinfo = await Firestore
                                    .instance
                                    .collection('users')
                                    .where("password", isEqualTo: password)
                                    .where("phone", isEqualTo: phone)
                                    .getDocuments();
                                final List<DocumentSnapshot> documents =
                                    userinfo.documents;
                                if (documents.length == 1) {
                                  documents.forEach((data) {
                                    prefs.setBool('login', true);
                                    prefs.setString('nmae', data['name']);
                                    prefs.setString('phone', data['phone']);
                                    prefs.setString('id', data.documentID);
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
                                  pr.dismiss();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'خطأ في تسجيل الدخول',
                                      textAlign: TextAlign.end,
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              },
                            ),
                          ),
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
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLogin', true);
                    prefs.setBool('login', true);
                    pr.show();
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
        ],
      ),
    );
  }
}
