import 'package:release/models/user.dart';
import 'package:release/routes/app_pages.dart';
import 'package:release/routes/app_routes.dart';
import 'package:release/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:release/services/init_database.dart';

void main() {
  initDatabase();

  final u = User(name: 'Eduarda', photo: 'eduarda.png', birthDate: '06/08/2004');
  var db = DatabaseService();
  db.insertEntity(model: u, tableName: 'users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriBook',
      initialRoute: AppRoutes.loginPage,
      onGenerateRoute: AppPages.onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
    );
  }
}
