import 'package:cafe/login_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageFive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
              "تطبيق جلسات",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Text(
                "قائمة الطلبات والأسعار المتوفرة لدى المقهى و جرس لاستدعاء مقدم الخدمة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
             Container(
          height:  MediaQuery.of(context).size.height * 0.20,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assests/images/service.png'),
            ),
          ),
        ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: RaisedButton(
                color: Colors.red[900],
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isNew', true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return Login();
                      },
                    ),
                  );
                },
                child: Text(
                  "الدخول للتطبيق",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
