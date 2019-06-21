import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

class DatabaseAdapter extends StatelessWidget {
  DatabaseAdapter({Key key, @required this.adapter, @required this.child})
      : super(key: key);

  final SqfliteAdapter adapter;
  final Widget child;

  static SqfliteAdapter of(BuildContext context){
    DatabaseAdapter provider = context.ancestorWidgetOfExactType(DatabaseAdapter);
    return provider.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}