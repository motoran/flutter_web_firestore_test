import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  //ここでFireStoreプロジェクトの設定を行う
  initializeApp(
    apiKey: "HOGE", //自分のプロジェクトのAPI KEYを設定する
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
  final fs.Firestore store = firestore();//クライアント作成
  final List<Map<String, dynamic>> messages = List();//FireStoreのデータ格納用LIST
  int num = 0;

  String _text = 'UNKNOWN';

  fetchMessages() async { //クラウドとの通信なので非同期
    var messagesRef = await store.collection('users').get();//Firestoreの　users　というcollectionを取得する

    messagesRef.forEach(
      (doc) {
        messages.add(doc.data());//ドキュメントをデータ格納用のListに保持する
      },
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          num ++;
          var m = Map<String, String>();
          m['user'] = _text + " : " + num.toString();
          await store.collection('users').add(m);//usersというcollectionに新しくドキュメントを追加
          setState(() {
            messages.add(m);//ローカルでも保持する(表示に利用)
          });
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: messages.map(
          (message) {
            return ListTile(title: Text(message['user']));//表示するロジック
          },
        ).toList(),
      ),
    );
  }
}
