import 'dart:async';
import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/login_screen/signup.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

StreamSubscription<DocumentSnapshot> subscription;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone, password, name, id, booked;
  bool check = false;
  List<String> idList = new List();
  List<String> nameList = new List();
  List<String> phoneList = new List();
  List<String> passwordList = new List();
  List<String> bookedList = new List();
  List<String> cafenameList = new List();
  List<int> cafeReviews = new List();
  List<int> starsAvrage = new List();

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

  void getallID() async {
    idList = [];
    nameList = [];
    phoneList = [];
    passwordList = [];
    bookedList = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      idList.add(data.documentID.toString());
      phoneList.add(data['phone']);
      passwordList.add(data['password']);
      nameList.add(data['name']);
      bookedList.add(data['booked']);
    });
  }

  @override
  void initState() {
    super.initState();
    getallID();
    getAllReviews();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assests/images/background-1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeAnimation(
                      1.3,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assests/images/background-2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1.5,
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Color.fromRGBO(49, 39, 79, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  phone = val;
                                });
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone number',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < phoneList.length; i++) {
                              if (phone == phoneList[i] &&
                                  password == passwordList[i]) {
                                setState(() {
                                  check = true;
                                  phone = phoneList[i];
                                  name = nameList[i];
                                  password = passwordList[i];
                                  id = idList[i];
                                  booked = bookedList[i];
                                });

                                break;
                              }
                            }

                            if (check) {
                              var info = UserInfo(
                                name: name,
                                phone: phone,
                                password: password,
                                id: id,
                                booked: booked,
                                reviewsCount: cafeReviews,
                                starsAvrage: starsAvrage,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return CafeList(
                                      info: info,
                                    );
                                  },
                                ),
                              );
                            } else {
                              print("no, you false");
                            }
                          });
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                    3,
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return SignUp();
                              },
                            ),
                          );
                        },
                        splashColor: Color.fromRGBO(49, 39, 79, 1),
                        child: Text(
                          'New user',
                          style: TextStyle(
                              color: Color.fromRGBO(196, 153, 198, 1),
                              fontWeight: FontWeight.bold),
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
