import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';

class TopPageViewModel extends ChangeNotifier {
  int pageIndex = 0;
  bool loadingFlag = true;
  String key;
  var streamController = StreamController<String>();

  // Stream<List<DocumentSnapshot>> get hoge => streamController.stream;
  Stream<String> get hoge => streamController.stream;
  String getKey() => this.key;
  List<DocumentSnapshot> data;

  List<String> sections = List();
  Map<int, List<String>> messages; //FireStoreのデータ格納用LIST
  fs.Firestore store;

  TopPageViewModel(String key) {
    this.key = key;
    store = firestore(); //クライアント作成
    fetchMessages(key);
  }

  fetchMessages(String key) async {
    var messagesRef = await store
        .collection("headings")
        .doc(key)
        .get();

    streamController.sink.add(messagesRef.data().length.toString());
  }
}
