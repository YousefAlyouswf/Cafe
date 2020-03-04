import 'package:cafe/start_pages/page_four.dart';
import 'package:cafe/start_pages/page_three.dart';
import 'package:cafe/start_pages/page_two.dart';
import 'package:cafe/start_pages/page_five.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';

class Tutorials extends StatefulWidget {
  @override
  _TutorialsState createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  List<Widget> pages = [PageTwo(), PageThree(), PageFour(), PageFive()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Container(
                    color: Colors.grey[600],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: ExactAssetImage('assests/images/logo.jpg'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  pages[index],
                ],
              );
            },
            onPageChanged: (index) {
              setState(() {
                pageIndexNotifier.value = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(120.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _displayIndector(),
            ),
          )
        ],
      ),
    );
  }

  Widget _displayIndector() {
    return PageViewIndicator(
      pageIndexNotifier: pageIndexNotifier,
      length: pages.length,
      normalBuilder: (animationController, index) => Circle(
        size: 8.0,
        color: Colors.grey,
      ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
        child: Circle(
          size: 12.0,
          color: Colors.green,
        ),
      ),
    );
  }
}
