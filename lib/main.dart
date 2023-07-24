///Created by: Godslove Lee
///Last edited: 25.07.2023
///Description: Root Project File

import 'package:flutter/material.dart';
import 'package:mentz_coding_challenge/widget/search_result_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JourneyPlanningApp(),
    );
  }
}
