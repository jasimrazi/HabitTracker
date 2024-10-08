import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracker/viewmodels/auth_viewmodel.dart';
import 'package:habit_tracker/viewmodels/habit_viewmodel.dart';
import 'package:habit_tracker/views/auth/splash_screen.dart';
import 'package:habit_tracker/views/auth/login_page.dart';
import 'package:habit_tracker/views/auth/signup_page.dart';
import 'package:habit_tracker/views/habitlist_page.dart';
import 'package:habit_tracker/views/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HabitViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/home': (context) => HomePage(),
          '/habitlist': (context) => HabitListPage(),
        },
      ),
    );
  }
}
