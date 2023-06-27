import 'package:flutter/material.dart';
import 'package:getxassignment/Services/entity_service.dart';

import 'Screens/home_screens.dart';
import 'package:sqflite/sqflite.dart';

/// The entity service
final entityService = EntityService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await entityService.initialize(); // Initialize the database

  // Access the database instance from the entityService
  // ignore: unused_local_variable
  Database database = entityService.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHome(),
    );
  }
}
