import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_v2/util/hex_color.dart';
import 'package:hci_v2/util/route_generator.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MaterialApp(
        theme: ThemeData(
          //Green
          primaryColor: HexColor("FF8BC34A"),
          //Charcoal
          primaryColorDark: HexColor("FF262626"),
          //Orange
          accentColor: HexColor("FFFF5026"),
          //Dark Gray
          backgroundColor: HexColor("FF363636"),

          fontFamily: 'Roboto',

          textTheme: TextTheme(
            headline: TextStyle(fontSize: 30, color: Colors.white),
            body1: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  });
}
