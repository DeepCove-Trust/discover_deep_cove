import 'package:flutter/material.dart';

class SizeableText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;

  const SizeableText(this.text, {this.align = TextAlign.center, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: size,
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}
