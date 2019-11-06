import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class meat_page extends StatefulWidget {
  @override
  _meat_page createState() => _meat_page();
}

int click;

class _meat_page extends State<meat_page> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  List<DocumentSnapshot> ingres;

  Future getMeat() async {
    FirebaseUser user = await _auth.currentUser();
    List<DocumentSnapshot> tmp;
//    await _db.collection('Fridge').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
//      tmp = docs.documents;
//    });
    _db
        .collection('Fridge')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((docs) {
      tmp = docs.documents;
      setState(() {
        ingres = tmp;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ingres != null ? ingres.length != 0 ? Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 1),
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Color(0xffC3C3C3),
                    alignment: Alignment.center,
                    child: Text('วัตถุดิบ',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Color(0xffE58200),
                    alignment: Alignment.center,
                    child: Text('คงเหลือ',
                      style: TextStyle(
                          fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Color(0xffE58200),
                    alignment: Alignment.center,
                    child: Text(
                      'วันที่เหลือ',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white),
                    ),
//                                child: Text(ingres[index].data['date'].toDate().toString()),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ingres == null ? 0 : ingres.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 100,
                        color: Colors.green,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: Color(0xffFCFCFC),
                                alignment: Alignment.center,
                                child: Text(
                                  ingres[index].data['name'],
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Color(0xffFC9002),
                                alignment: Alignment.center,
                                child: Text(
                                  ingres[index].data['num'] +
                                      ' ' +
                                      ingres[index].data['unit'],
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      Container(
                                        color: Color(0xffFFA733),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '11 วัน',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
//                                child: Text(ingres[index].data['date'].toDate().toString()),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: Text(
                                          '${ingres[index].data['date'].toDate().day.toString()}/${ingres[index].data['date'].toDate().month.toString()}/${ingres[index].data['date'].toDate().year.toString()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        color: Color(0xffFC9002),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return add_page();
              }));
            },
            child: Container(
              alignment: Alignment.center,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.add,
                      size: 25,
                    ),
                  ),
                  Container(
                    child: Text(
                      "เพิ่ม",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    ):Column(
      children: <Widget>[
        Expanded(
          child: Container(
              alignment: Alignment.center,
              child: Text("ไม่มีวัตถุดิบ",style: TextStyle(fontSize: 25),)
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return add_page();
            }));
          },
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.add,
                    size: 25,
                  ),
                ),
                Container(
                  child: Text(
                    "เพิ่ม",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ):Container();
  }
}
