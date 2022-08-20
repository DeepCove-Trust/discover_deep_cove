import 'package:flutter/material.dart';

abstract class VerboseState<T extends StatefulWidget> extends State<T> {
  String name;

  VerboseState() {
    name = this.runtimeType.toString();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    print('$name built');
  }

  @override
  @mustCallSuper
  void deactivate() {
    print('$name deactivated');
    super.deactivate();
  }

  @override
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
    print('$name updated');
    super.didUpdateWidget(oldWidget);
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    print('$name changed dependencies');
    super.didChangeDependencies();
  }

  @override
  @mustCallSuper
  void dispose() {
    print('$name disposed');
    super.dispose();
  }

  @override
  @mustCallSuper
  void reassemble() {
    print('$name reassembled');
    super.reassemble();
  }

  @override
  @mustCallSuper
  void initState() {
    print('$name initialized');
    super.initState();
  }
}
