import 'package:discover_deep_cove/data/db.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

/// This widget serves as a container widget which should be placed high up
/// in the widget tree. Descendant widgets can use the [of] method to access
/// the adapter object of this widget.
class DatabaseAdapter extends StatelessWidget {
  DatabaseAdapter({Key key, @required this.adapter, @required this.child})
      : super(key: key);

  final SqfliteAdapter adapter;
  final Widget child;

  /// Returns the adapter to the database
  static SqfliteAdapter of(BuildContext context) {
    DatabaseAdapter provider =
        context.ancestorWidgetOfExactType(DatabaseAdapter);
    return provider.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
