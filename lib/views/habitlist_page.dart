import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/viewmodels/auth_viewmodel.dart';
import 'package:habit_tracker/viewmodels/habit_viewmodel.dart';
import 'package:provider/provider.dart';

class HabitListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitViewModel = Provider.of<HabitViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Habit List'),
      actions: [
          IconButton(
              onPressed: () async {
                await context.read<AuthViewModel>().signOut();
                // You can also add navigation to the login screen if needed
                Navigator.of(context).pushReplacementNamed('/login');
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: ListView.builder(
        itemCount: habitViewModel.habits.length,
        itemBuilder: (context, index) {
          final habit = habitViewModel.habits[index];
          return ListTile(
            title: Text(habit.name),
            trailing: Checkbox(
              value: habit.isCompleted,
              onChanged: (value) {
                habitViewModel.toggleCompletion(habit.id);
              },
            ),
            onLongPress: () {
              _showEditDialog(context, habit);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter habit name'),
            onSubmitted: (name) {
              Provider.of<HabitViewModel>(context, listen: false)
                  .addHabit(name);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Habit'),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: habit.name),
            decoration: InputDecoration(hintText: 'Enter new habit name'),
            onSubmitted: (name) {
              Provider.of<HabitViewModel>(context, listen: false)
                  .editHabit(habit.id, name);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<HabitViewModel>(context, listen: false)
                    .deleteHabit(habit.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
