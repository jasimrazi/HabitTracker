import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HabitViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  HabitViewModel() {
    _fetchHabits();
  }

  // Get the current user's ID
  String get _userId {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is currently logged in');
    }
  }

  // Fetch habits from Firestore
  Future<void> _fetchHabits() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('habits')
          .get();

      _habits = snapshot.docs
          .map((doc) => Habit.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching habits: $e');
    }
  }

  // Add a new habit to Firestore
  Future<void> addHabit(String name) async {
    try {
      final newHabit = Habit(
        id: DateTime.now().toString(),
        name: name,
      );
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('habits')
          .doc(newHabit.id)
          .set(newHabit.toMap());
      _habits.add(newHabit);
      notifyListeners();
    } catch (e) {
      print('Error adding habit: $e');
    }
  }

  // Edit an existing habit in Firestore
  Future<void> editHabit(String id, String newName) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('habits')
          .doc(id)
          .update({'name': newName});

      final index = _habits.indexWhere((habit) => habit.id == id);
      if (index != -1) {
        _habits[index] = Habit(
          id: id,
          name: newName,
          isCompleted: _habits[index].isCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error editing habit: $e');
    }
  }

  // Delete a habit from Firestore
  Future<void> deleteHabit(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('habits')
          .doc(id)
          .delete();

      _habits.removeWhere((habit) => habit.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }

  // Mark a habit as completed or not completed
  Future<void> toggleCompletion(String id) async {
    try {
      final index = _habits.indexWhere((habit) => habit.id == id);
      if (index != -1) {
        final habit = _habits[index];
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('habits')
            .doc(id)
            .update({'isCompleted': !habit.isCompleted});

        _habits[index] = Habit(
          id: id,
          name: habit.name,
          isCompleted: !habit.isCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling completion: $e');
    }
  }
}
