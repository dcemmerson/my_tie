import 'package:flutter/material.dart';
import 'package:my_tie/routes/routes.dart';

class MyTieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
    );
  }
}
