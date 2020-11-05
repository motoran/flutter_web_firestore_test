import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webapp/view/topPage_view.dart';
import 'package:flutter_webapp/view/topPage_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  //ここでFireStoreプロジェクトの設定を行う
  initializeApp(
    apiKey: "AIzaSyAApo68kXRUXfpgXUgf_oVdGFPHxpXUMSc",
    //自分のプロジェクトのAPI KEYを設定する
    authDomain: "moto-blog-flutter.firebaseapp.com",
    databaseURL: "https://moto-blog-flutter.firebaseio.com",
    projectId: "moto-blog-flutter",
    storageBucket: "moto-blog-flutter.appspot.com",
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fs.Firestore store = firestore(); //クライアント作成
  final List<String> headings = List(); //FireStoreのデータ格納用LIST
  String _text = 'アンパンマン';

  fetchHeadings() async {
    //クラウドとの通信なので非同期
    var messagesRef = await store
        .collection('headings')
        .get(); //Firestoreの　users　というcollectionを取得する

    messagesRef.forEach(
      (doc) {
        headings.add(doc.id); //ドキュメントをデータ格納用のListに保持する
      },
    );

    setState(() {});
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  Widget _viewDialog() {
    return AlertDialog(
        title: Text("新規カード名を入力してください"),
        content: TextField(
          enabled: true,
          // 入力数
          maxLength: 30,
          maxLengthEnforced: false,
          style: TextStyle(color: Colors.red),
          obscureText: false,
          maxLines: 1,
          //パスワード
          onChanged: _handleText,
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("add"),
            onPressed: () async {
              var m = Map<String, String>();
              m["comment"] = "sec1";
              await store.collection('headings').doc(_text).set(m);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text("no"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }

  @override
  void initState() {
    super.initState();
    fetchHeadings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 16,
          crossAxisSpacing: 5,
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        scrollDirection: Axis.vertical,
        primary: false,
        padding: const EdgeInsets.all(10),
        itemCount: headings.length,
        itemBuilder: (BuildContext context, int index) {
          return topPageCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return _viewDialog();
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }

  Widget topPageCard(BuildContext buildContext, int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => TopPageViewModel(headings[index]),
                child: TopPageView(),
              ),
            ),
          );
        },
        child: Card(
          elevation: 2.0,
          color: Colors.white70,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox.fromSize(size: Size.fromHeight(8)),
                Text(
                  "　" + "${headings[index]}",
                  //本当はRawを追加して余白設定するほうが良いけど、面倒なのでSpaceでレイアウトをそろえてる
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox.fromSize(size: Size.fromHeight(8)),
                Text(
                  "　" + "説明欄",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ]),
        ),
      ),
    );
  }
}
