import 'package:flutter/material.dart';

class PageFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                "أيضا يمكنك الإطلاع على الجلسات في المقهى ومعرفة رقم الجلسة المتاحة وحجزها عبر ادخال كود المقهى الموجود عند مدخل المقهى",
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
              image: ExactAssetImage('assests/images/seats.png'),
            ),
          ),
        ),
          ],
        );
  }
}