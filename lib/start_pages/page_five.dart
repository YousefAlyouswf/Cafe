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
                "خدمات تطبيق هوكا",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Text(
                "بعد أختيارك للجسلة المتاحة يمكنك الإطلاع على قائمة الطلبات والأسعار المتوفرة لدى المقهى وكذلك يوجد جرس لاستدعاء مقدم الخدمة لك",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
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
                color: Colors.red,
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
