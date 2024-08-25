import 'package:flutter/material.dart';
import 'package:habit_tracker/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () async {
            await context.read<AuthViewModel>().signOut();
                // You can also add navigation to the login screen if needed
                Navigator.of(context).pushReplacementNamed('/login');
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
