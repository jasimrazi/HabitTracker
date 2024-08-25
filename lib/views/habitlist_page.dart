import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/utils/date_formatter.dart';
import 'package:habit_tracker/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/viewmodels/habit_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitListPage extends StatefulWidget {
  @override
  _HabitListPageState createState() => _HabitListPageState();
}

class _HabitListPageState extends State<HabitListPage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarVisible = false;
  late AnimationController _controller;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void _toggleCalendarVisibility() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
      _isCalendarVisible ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitViewModel = Provider.of<HabitViewModel>(context);
    final habits = habitViewModel.getHabitsForDate(_selectedDate);

    final String formattedDate = formatDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit List'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthViewModel>().signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleCalendarVisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select Date'),
                  SizedBox(width: 8),
                  RotationTransition(
                    turns: _arrowAnimation,
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _isCalendarVisible
                  ? Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _selectedDate,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDate, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                          });
                        },
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(height: 30),
            Text('Your Habits for $formattedDate'),
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Text(
                        'No habits',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return ListTile(
                          title: Text(habit.name),
                          trailing: Checkbox(
                            value: habit.isCompleted,
                            onChanged: (bool? value) {
                              // Toggle completion logic
                              Provider.of<HabitViewModel>(context,
                                      listen: false)
                                  .toggleCompletion(habit.id);
                            },
                          ),
                          onTap: () => _showEditDialog(context, habit),
                        );
                      },
                    ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
            Provider.of<HabitViewModel>(context, listen: false).addHabit(name);
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
