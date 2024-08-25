import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String id;
  String name;
  bool isCompleted;

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
  });

  // Convert a Habit object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
    };
  }

  // Convert a Map object into a Habit object
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
