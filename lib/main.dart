import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_maids/Screen/todoview.dart';

import 'Screen/loginscreen.dart';
import 'routes/approutes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return GetMaterialApp(
      title: 'Candidates App',
       getPages: AppRoutes.appRoutes().toList(), // Convert Set to List
    );
  }
}
