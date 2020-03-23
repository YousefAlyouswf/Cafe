import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
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
                fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Center(
          child: Text(
            "يحتوي على مجموعه من المقاهي في المملكة العربية السعودية ويمكنك تحديد المدينة من قائمة المدن",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height:  MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assests/images/cities.png'),
            ),
          ),
        ),
        
      ],
    );
  }
}
