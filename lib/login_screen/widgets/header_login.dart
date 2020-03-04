import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  final double width;

  const HeaderLogin({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height *0.25,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assests/images/logo-1.png'),
      //     fit: BoxFit.fitHeight,
      //   ),
      // ),
      child: Stack(
        children: <Widget>[
          // Positioned(
          //   left: 30,
          //   width: 80,
          //   height: height/4,
          //   child: FadeAnimation(
          //     1,
          //     Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assests/images/light-1.png'),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: 140,
          //   width: 80,
          //   height: 150,
          //   child: FadeAnimation(
          //     1.3,
          //     Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assests/images/light-2.png'),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   right: 40,
          //   top: 40,
          //   width: 80,
          //   height: 150,
          //   child: FadeAnimation(
          //     1.5,
          //     Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assests/images/clock.png'),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
