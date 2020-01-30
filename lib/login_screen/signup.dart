import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name;
  String phone;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assests/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assests/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assests/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                        1.5,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assests/images/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeAnimation(
                        1.6,
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                  bottom: BorderSide(color: Colors.grey[100]),
                                ),
                              ),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
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
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    phone = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                onChanged: (val) {
                                  password = val;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
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
                      InkWell(
                        onTap: () {
                          SigninFiresotre().addUser(name, phone, password);
                          UserInfo(
                              name: name, phone: phone, password: password);
                              
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return Login();
                              },
                            ),
                          );
                        },
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 14, 251, 1),
                                Color.fromRGBO(143, 14, 251, .6),
                              ])),
                          child: Center(
                            child: Text("Sign up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
