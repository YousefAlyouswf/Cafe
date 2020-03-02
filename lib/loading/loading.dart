import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/f8442951656711.59353e402767a.gif'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
