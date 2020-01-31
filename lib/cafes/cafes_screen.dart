import 'package:cafe/cafes/reviews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_info.dart';

class CafeList extends StatefulWidget {
  final UserInfo info;

  const CafeList({Key key, this.info}) : super(key: key);
  @override
  _CafeListState createState() => _CafeListState();
}

class _CafeListState extends State<CafeList> {
  bool sort = false;
  String city;
  String filterCity;
  bool check = false;

  //To Show user Info START
  String userID;
  String userName;
  String userPhone;
  String userPassword;
  String booked;
  String seatNum;

  //To Show user Info END
  List<String> cityList = new List();
  List<dynamic> removeDoublicat = new List();

  void getallcity() async {
    cityList = [];
    removeDoublicat = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('cafes').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      cityList.add(data['city']);
    });
    setState(() {
      removeDoublicat = cityList.toSet().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getallcity();
  }

  @override
  Widget build(BuildContext context) {
    userID = widget.info.id;
    userName = widget.info.name;
    userPhone = widget.info.phone;
    userPassword = widget.info.password;
    booked = widget.info.booked;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text(
          "قائمة المقاهي",
          style: TextStyle(
              fontFamily: 'arbaeen', fontWeight: FontWeight.bold, fontSize: 28),
        )),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/ar/thumb/6/68/General_Entertainment_Authority_Logo.svg/1200px-General_Entertainment_Authority_Logo.svg.png'),
            )),
          ),
          ListTile(
            title: Center(
                child: Text(
              "أختر المدينة",
              style: TextStyle(fontSize: 24),
            )),
            trailing: Icon(Icons.map),
          ),
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: removeDoublicat.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Center(
                    child: ListTile(
                      title: Text(
                        removeDoublicat[index],
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.location_city),
                      onTap: () {
                        setState(() {
                          filterCity = removeDoublicat[index];
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('cafes')
              .where('city', isEqualTo: filterCity)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  String image =
                      snapshot.data.documents[index].data['image'].toString();
                  String cafeName =
                      snapshot.data.documents[index].data['name'].toString();
                  int starsSum = widget.info.starsAvrage[index];
                  int reviewsCount = widget.info.reviewsCount[index];
                  double result = starsSum/reviewsCount;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridTile(
                      child: Image.network(
                        image,
                        fit: BoxFit.fill,
                      ),
                      footer: Container(
                        height: 70,
                        child: GridTileBar(
                          backgroundColor: Colors.black87,
                          leading: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color:
                                    result >= 1 ? Colors.yellow : Colors.grey,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    result >= 2 ? Colors.yellow : Colors.grey,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    result >= 3 ? Colors.yellow : Colors.grey,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    result >= 4 ? Colors.yellow : Colors.grey,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    result >= 5 ? Colors.yellow : Colors.grey,
                              ),
                            ],
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  'التعليقات $reviewsCount'),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return Reviews(
                                          cafeName: cafeName,
                                          info: widget.info,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  cafeName,
                                  style: TextStyle(
                                      fontFamily: 'topaz', fontSize: 23),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
