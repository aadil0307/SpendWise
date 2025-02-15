import 'package:flutter/material.dart';
import 'package:Tracketizer/locator.dart';
import 'package:Tracketizer/ui/router.dart' as ru;
import 'package:Tracketizer/ui/shared/app_colors.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracketizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: ru.Router.generateRoute,
    );
  }
}
