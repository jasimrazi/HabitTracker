import 'package:flutter/material.dart';
import 'package:habit_tracker/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    try {
      await authViewModel.checkAuthStatus();
      if (authViewModel.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/habitlist');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      print('Error checking auth status: $error');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              CircularProgressIndicator()), // Show a loading indicator while checking auth status
    );
  }
}
