import 'package:flutter/material.dart';

class PageThree extends StatelessWidget {
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
                "بعد أختيارك للمقهى يمكنك قراءة تعليقات الزوار وتقيمهم للمقهى ويمكنك التقييم كذلك",
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
              image: ExactAssetImage('assests/images/reviews.png'),
            ),
          ),
        ),
          ],
        ),
       
      ],
    );
  }
}
