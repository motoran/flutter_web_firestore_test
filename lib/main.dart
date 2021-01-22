import 'package:excel/excel.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:html' as html;

import 'package:flutter_webapp/content_data.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  //ここでFireStoreプロジェクトの設定を行う
  initializeApp(

  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter勉強用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  bool isContentShow = false;
  final ContentData _contentData = ContentData();
  int fortune, content;
  int contentSize = 30;
  int random = math.Random().nextInt(30);
  List<String> title = [], url = [], imageUrl = [], artist = [];

  @override
  void initState() {
    super.initState();
    readExcel();
  }

  void readExcel() async {
    ByteData data = await rootBundle.load("assets/Book1.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
        title.add(row[0].toString());
        url.add(row[1].toString());
        imageUrl.add(row[2].toString());
        artist.add(row[3].toString());
      }
    }
  }

  void lottery() {
    var random = math.Random().nextInt(100);
    if (random >= 0 && 16 >= random) {
      fortune = 0;
    }
    if (random >= 17 && 51 >= random) {
      fortune = 1;
    }
    if (random >= 52 && 56 >= random) {
      fortune = 2;
    }
    if (random >= 57 && 60 >= random) {
      fortune = 3;
    }
    if (random >= 61 && 63 >= random) {
      fortune = 4;
    }
    if (random >= 64 && 69 >= random) {
      fortune = 5;
    }
    if (random >= 70 && 99 >= random) {
      fortune = 6;
    }
    this.random = math.Random().nextInt(contentSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('推し布教おみくじ ver0.2.1'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
            child: Card(
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 3),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text('おみくじ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('運勢の確率は浅草寺のおみくじを参考にしています。\n\n'),
                      ),
                      RaisedButton(
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        child: Text(isContentShow ? 'おみくじを閉じる' : 'おみくじを引く'),
                        onPressed: () {
                          setState(() {
                            isContentShow = !isContentShow;
                            if (isContentShow) lottery();
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      contentWidget(title[random], url[random],
                          imageUrl[random], artist[random]),
                      SizedBox(height: 50),
                      // Padding(
                      //   padding: EdgeInsets.all(15),
                      //   child: Text('不具合はこちらまで\n(twitter @sys_moto)\n'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentWidget(
      String title, String url, String imageUrl, String artist) {
    return AnimatedContainer(
      width: isContentShow
          ? (MediaQuery.of(context).size.width > 400
              ? 380
              : MediaQuery.of(context).size.width - 10)
          : 0,
      height: isContentShow ? 250.0 : 0,
      alignment:
          isContentShow ? Alignment.center : AlignmentDirectional.topCenter,
      duration: Duration(milliseconds: 300),
      foregroundDecoration: BoxDecoration(
          border:
              Border.all(color: Colors.black26, width: isContentShow ? 1 : 0)),
      curve: Curves.fastOutSlowIn,
      child: isContentShow
          ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      _contentData.fortune[fortune ?? 5],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.lightBlue, width: 1),
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: isContentShow ? 80 : 0,
                                      height: isContentShow ? 80 : 0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(imageUrl),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 3),
                                          Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            artist,
                                            style: TextStyle(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]),
                                  ]),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom:10,
                          right: 10,
                          child: RaisedButton.icon(
                            color: Colors.white60,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("聞く"),
                            onPressed: () async {
                              html.window.location.href = url;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ]),
            )
          : Container(),
    );
  }
}
