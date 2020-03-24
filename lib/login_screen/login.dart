import 'dart:async';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/login_screen/widgets/login_widget.dart';
import 'package:cafe/login_screen/widgets/signup_widget.dart';
import 'package:cafe/start_pages/tutorials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamSubscription<DocumentSnapshot> subscription;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TabController _controller;
  //Progress dialog
  ProgressDialog pr;

  //--------------
  String phone, password;

  List<int> cafeReviews = new List();

  String nameForSignup;

  String phoneForSignup;

  String passwordForSignup;

  String errorMsg = '';

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
      Firestore.instance
          .collection('cafes')
          .document(data.documentID)
          .updateData(
              {'stars': sum.toString(), 'reviewcount': data['reviews'].length});

      count++;
    });
  }

  TextEditingController phoneText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController phoneTextReg = TextEditingController();
  TextEditingController passwordTextReg = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocusReg = FocusNode();
  final FocusNode _passwordFocusReg = FocusNode();
  final FocusNode _nameFocusReg = FocusNode();
//-- determine if user is new or not
  bool isNew = false;

  @override
  void initState() {
    isUserNew().then((onValue) {
      setState(() {
        isNew = onValue;
      });

      if (!isNew) {
        goThere = Tutorials();
      }
    });
    super.initState();
    getAllReviews();
    _controller = TabController(length: 2, vsync: this);
  }

  Widget goThere = Loading();
  Future<bool> isUserNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNew = prefs.getBool('isNew');
    if (isNew == null) {
      isNew = false;
    }
    return isNew;
  }

  @override
  Widget build(BuildContext context) {
//progress dialog
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: '...أنتظر قليلا',
        progressWidget: Container(
          height: 200,
 
        ));

//----------

    if (isNew == false) {
      return goThere;
    } else {
      return WillPopScope(
        onWillPop: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Colors.red[900],
              bottom: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'topaz',
                    fontWeight: FontWeight.w900),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'تسجيل',
                  ),
                  Tab(
                    text: 'دخول',
                  ),
                ],
                controller: _controller,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assests/images/cafe_logo.jpg'),
                  fit: BoxFit.none,
                  alignment: Alignment.topCenter),
            ),
            child: TabBarView(
              children: <Widget>[
                SignUpWidget(
                  _fieldFocusChange,
                  _passwordFocusReg,
                  _nameFocusReg,
                  _phoneFocusReg,
                  errorMsg,
                  phoneTextReg,
                  passwordTextReg,
                  phoneForSignup,
                  passwordForSignup,
                  phone,
                  nameForSignup,
                  pr,
                ),
                LoginWidget(
                  pr,
                  phone,
                  phoneText,
                  passwordText,
                  _passwordFocus,
                  _phoneFocus,
                  _fieldFocusChange,
                ),
              ],
              controller: _controller,
            ),
          ),
        ),
      );
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
