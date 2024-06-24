import 'package:flutter/material.dart';
import 'package:flutter_newsapp/home_page.dart';

void main() => runApp(const MyApp());
// GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
}
}
