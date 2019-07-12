import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Center(
          child: Text('Put something here...'),
        ),
      ),
    );
  }
}