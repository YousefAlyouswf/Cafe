import 'package:cafe/animation/fadeAnimation.dart';
import 'package:flutter/material.dart';


class PushToSignUp extends StatelessWidget {
  final Function showToast;
final String change;
  const PushToSignUp({Key key, this.showToast, this.change}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        FadeAnimation(
          3,
          Center(
            child: InkWell(
              onTap: showToast,
              child: Text(
                change,
                style: TextStyle(
                    color: Color.fromRGBO(196, 153, 198, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'topaz',
                    fontSize: 35),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
