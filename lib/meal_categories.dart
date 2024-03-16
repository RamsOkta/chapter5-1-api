import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'category.dart';
import 'meal_list.dart';

void main() {
  runApp(MealApp());
}

class MealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Categories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MealHomePage(),
    );
  }
}
