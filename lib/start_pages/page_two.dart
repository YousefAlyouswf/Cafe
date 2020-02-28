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
            "ماذا يقدم تطبيق هوكا؟",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
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
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height:  MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assests/images/menu_bar.jpg'),
            ),
          ),
        ),
         Container(
          height:  MediaQuery.of(context).size.height * 0.20,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assests/images/city_menu.jpg'),
            ),
          ),
        ),
      ],
    );
  }
}
