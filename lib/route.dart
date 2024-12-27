import 'package:flutter/material.dart';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:hrms/utils/Widget/bottamNavigationWidget.dart';

class RouterWidget extends StatefulWidget {
  const RouterWidget({super.key});

  @override
  State<RouterWidget> createState() => _RouterWidgetState();
}

class _RouterWidgetState extends State<RouterWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hrms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const BottamnavigationBar(),
      },
    );
  }
}
