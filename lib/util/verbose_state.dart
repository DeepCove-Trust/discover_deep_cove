import 'package:flutter/material.dart';

abstract class VerboseState<T extends StatefulWidget> extends State<T> {
  String name;

  VerboseState() {
    name = this.runtimeType.toString();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    debugPrint('$name built');
  }

  @override
  @mustCallSuper
  void deactivate() {
    debugPrint('$name deactivated');
    super.deactivate();
  }

  @override
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
    debugPrint('$name updated');
    super.didUpdateWidget(oldWidget);
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    debugPrint('$name changed dependencies');
    super.didChangeDependencies();
  }

  @override
  @mustCallSuper
  void dispose() {
    debugPrint('$name disposed');
    super.dispose();
  }

  @override
  @mustCallSuper
  void reassemble() {
    debugPrint('$name reassembled');
    super.reassemble();
  }

  @override
  @mustCallSuper
  void initState() {
    debugPrint('$name initialized');
    super.initState();
  }
}
