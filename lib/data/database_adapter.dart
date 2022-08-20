import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

import 'db.dart';

/// This widget serves as a container widget which should be placed high up
/// in the widget tree. Descendant widgets can use the [of] method to access
/// the adapter object of this widget.
class DatabaseAdapter extends StatelessWidget {
  const DatabaseAdapter({
    Key key,
    @required this.adapter,
    @required this.child,
  }) : super(key: key);

  final SqfliteAdapter adapter;
  final Widget child;

  /// Returns the adapter to the database
  static SqfliteAdapter of(BuildContext context) {
    DatabaseAdapter provider = context.findAncestorWidgetOfExactType<DatabaseAdapter>();
    return provider.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
