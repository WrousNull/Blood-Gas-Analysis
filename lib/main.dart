import 'package:flutter/material.dart';

import './pages/home_page.dart';
import 'pages/answer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Medical Calculator",
      routes: {
        '/': (context) => HomePage(),
        '/answer': (context) => const Answer(),
      },
    );
  }
}