import 'package:flutter/material.dart';
import 'package:sempleprasant/pages/login_page.dart';




void main() {
  runApp( ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدير المصروفات الشخصية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // يمكن تغيير الخط حسب الحاجة
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}