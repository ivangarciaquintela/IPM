import 'package:flutter/material.dart';
import 'package:recetas_app/Master.dart';

// ignore: constant_identifier_names
const String app_title = "Recetas App";

class RecetasApp extends StatelessWidget {
  final String title;

  const RecetasApp({super.key, this.title = app_title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Master(title: title),
    );
  }
}
