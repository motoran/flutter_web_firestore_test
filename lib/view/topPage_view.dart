import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webapp/view/topPage_viewmodel.dart';
import 'package:provider/provider.dart';

class TopPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TopPageViewModel _vm =
        Provider.of<TopPageViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text( _vm.getKey() ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: StreamBuilder<String>(
          stream: _vm.hoge,
          builder: (_, snapshot) {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Container(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            }
            return Container(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, int index) {
                    // return Text(snapshot.data.elementAt(index).data()["comment"].toString());
                    return Text(snapshot.data);
                  }),
            );
          },
        ),
      ),
    );
  }
}
