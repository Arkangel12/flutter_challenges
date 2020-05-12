import 'package:flutter/material.dart';

class GravityItems extends StatelessWidget {
  static Route<dynamic> route(){
      return MaterialPageRoute(
        builder: (BuildContext context) => GravityItems(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text('Welcome to the Dart Side'),
      ),
    );
  }
}
