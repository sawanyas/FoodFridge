import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taluewapp/Services/Ingredient.dart';
import 'package:provider/provider.dart';

class xwater_choose_page extends StatefulWidget {
  @override
  _xwater_choose_page createState() => _xwater_choose_page();
}

int click;

class _xwater_choose_page extends State<xwater_choose_page> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  List<DocumentSnapshot> ingres;
  Ingredient ingredient;
  bool isLoaded = false;
  Ingredient _ingredient;

  Future getMeat() async {
    FirebaseUser user = await _auth.currentUser();
    List<DocumentSnapshot> tmp;
    _db
        .collection('Fridge')
        .where('uid', isEqualTo: user.uid)
        .where('type', isEqualTo:'water')
        .snapshots()
        .listen((docs) {
      tmp = docs.documents;
      setState(() {
        ingres = tmp;
      });
    });
  }

  Map<String, dynamic> checkIngredients(ingredientToFind, name) {
    bool isHas = false;
    int index = 0;

    for (int i = 0; i < ingredientToFind.length ; i++) {
      if(name == ingredientToFind[i]['name']){
        isHas = true;
        index = i;
        break;
      }
    }

    return {
      "isHas": isHas,
      "index": index
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      _ingredient = Provider.of<Ingredient>(context);
      isLoaded = true;
    }
  }

  calculateDate(DateTime date1) {
    int date1Day = date1.day;
    int date1Month = date1.month;
    int date1Year = date1.year;

    int date2Day = DateTime.now().day;
    int date2Month = DateTime.now().month;
    int date2Year = DateTime.now().year;

    return date2Day - date1Day;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(20),
      child: ingres != null
          ? ingres.length != 0
          ? Container(
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
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding:
                              EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                'วัตถุดิบ',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Color(0xffE58200),
                        alignment: Alignment.center,
                        child: Text(
                          'คงเหลือ',
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
                              fontSize: 25, color: Colors.white),
                        ),
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
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(checkIngredients(_ingredient.getIngredients(), ingres[index]['name'])['isHas']){
                                  int indexToDelete = checkIngredients(_ingredient.getIngredients(), ingres[index]['name'])['index'];
                                  _ingredient.removeIngredients(indexToDelete);
                                }else{
                                  Map<String, String> tmp = {
                                    'name': ingres[index]['name'],
                                    'num': ingres[index]['num'].toString(),
                                    'unit': ingres[index]['unit']
                                  };

                                  _ingredient.addIngredients(tmp);
                                  print(_ingredient.getIngredients());
                                }
                              });
                            },
                            child: Container(
                              height: 100,
                              color: Colors.green,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      color: Color(0xffECECEC),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Container(
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      color: checkIngredients(_ingredient.getIngredients(), ingres[index].data['name'])['isHas']
                                                          ? Colors.red
                                                          : Colors.white,
                                                      shape:
                                                      BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors
                                                              .red)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              ingres[index].data['name'],
                                              style:
                                              TextStyle(fontSize: 25),
                                            ),
                                          ),
                                        ],
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
                                            fontSize: 25,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Stack(
                                          alignment:
                                          Alignment.bottomCenter,
                                          children: <Widget>[
                                            Container(
                                              color: Color(0xffFFA733),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${6} วัน',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
//                                child: Text(ingres[index].data['date'].toDate().toString()),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                calculateDate(
                                                    ingres[index]
                                                        .data['date']
                                                        .toDate());
                                              },
                                              child: Container(
                                                alignment:
                                                Alignment.center,
                                                height: 30,
                                                child: Text(
                                                  '${ingres[index].data['date'].toDate().day.toString()}/${ingres[index].data['date'].toDate().month.toString()}/${ingres[index].data['date'].toDate().year.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                      Colors.white),
                                                ),
                                                color: Color(0xffFC9002),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
              ),
            ],
          ))
          : Column(
        children: <Widget>[
          Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  "ไม่มีวัตถุดิบ",
                  style: TextStyle(fontSize: 25),
                )),
          ),
          GestureDetector(
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
          : Container(),
    );
  }
}
