
import 'package:flutter/material.dart';
import 'screen/teacher_home_screen.dart';

void main() {
  runApp(const EduBridgeApp());
}

class EduBridgeApp extends StatelessWidget {
  const EduBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduBridge',
      home: const TeacherHomeScreen(),
    );
  }
}
